# == Class: cubbystack::kuryr
#
# Configures the kuryr package and kuryr.conf
#
# === Parameters
#
# [*settings*]
#   A hash of key => value settings to go in kuryr.conf
#
# [*package_ensure*]
#   The status of the kuryr package
#   Defaults to present
#
# [*config_file*]
#   The path to kuryr.conf
#   Defaults to /etc/kuryr/kuryr.conf
#
class cubbystack::kuryr (
  $settings,
  $package_ensure = present,
  $service_ensure = 'running',
  $service_enable = true,
  $config_file    = '/etc/kuryr/kuryr.conf',
) {

  contain ::cubbystack::params

  ## Meta settings and globals
  $tags = ['cubbystack_openstack', 'cubbystack_kuryr']

  # Make sure kuryr is installed before configuration begins
  File<| tag == 'cubbystack_kuryr' |> -> Cubbystack_config<| tag == 'cubbystack_kuryr' |>
  Cubbystack_config<| tag == 'cubbystack_kuryr' |> -> Service<| tag == 'cubbystack_kuryr' |>

  # Restart kuryr services whenever kuryr.conf has been changed
  Cubbystack_config<| tag == 'cubbystack_kuryr' |> ~> Service<| tag == 'cubbystack_kuryr' |>

  # Global file attributes
  File {
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    tag     => $tags,
  }

  file { '/etc/kuryr':
    ensure => directory,
  }

  # Kuryr package
  vcsrepo { '/srv/kuryr':
    ensure   => present,
    provider => git,
    owner    => 'kuryr',
    group    => 'kuryr',
    source   => 'https://github.com/openstack/kuryr-libnetwork/',
  }

  python::requirements { '/srv/kuryr/requirements.txt':
    require => Vcsrepo['/srv/kuryr'],
    notify  => Exec['install kuryr'],
  }

  exec { 'install kuryr':
    path        => ['/bin', '/usr/bin'],
    command     => 'python setup.py install',
    cwd         => '/srv/kuryr',
    refreshonly => true,
    notify      => Exec['create kuryr.conf'],
    tag         => ['cubbystack_kuryr_install'],
  }

  exec { 'create kuryr.conf':
    path        => ['/bin', '/usr/bin'],
    command     => 'bash tools/generate_config_file_samples.sh',
    cwd         => '/srv/kuryr',
    refreshonly => true,
    tag         => ['cubbystack_kuryr_install', 'cubbystack_kuryr_kuryr.conf'],
  }

  file { '/etc/kuryr/kuryr.conf':
    source  => '/srv/kuryr/etc/kuryr.conf.sample',
    replace => false,
    require => Exec['create kuryr.conf'],
  }

  file { '/etc/systemd/system/kuryr-libnetwork.service':
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode   => '0640',
    source => 'puppet:///modules/cubbystack/kuryr/kuryr-libnetwork.service',
    tag    => $tags,
  }

  service { 'kuryr-libnetwork':
    ensure  => $service_ensure,
    enable  => $service_enable,
    tag     => $tags,
    require => File['/etc/systemd/system/kuryr-libnetwork.service'],
  }

  ## Configure kuryr.conf
  $settings.each |$setting, $value| {
    cubbystack_config { "${config_file}: ${setting}":
      value => $value,
      tag   => $tags,
    }
  }

}
