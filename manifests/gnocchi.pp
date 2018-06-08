# == Class: cubbystack::gnocchi
#
# Configures the gnocchi package and gnocchi.conf
#
# === Parameters
#
# [*settings*]
#   A hash of key => value settings to go in gnocchi.conf
#
# [*package_ensure*]
#   The status of the gnocchi package
#   Defaults to present
#
# [*config_file*]
#   The path to gnocchi.conf
#   Defaults to /etc/gnocchi/gnocchi.conf
#
class cubbystack::gnocchi (
  $settings,
  $package_ensure = present,
  $config_file    = '/etc/gnocchi/gnocchi.conf',
) {

  contain ::cubbystack::params

  ## Meta settings and globals
  $tags = ['cubbystack_openstack', 'cubbystack_gnocchi']

  # Make sure gnocchi is installed before configuration begins
  File<| tag == 'cubbystack_gnocchi' |> -> Cubbystack_config<| tag == 'cubbystack_gnocchi' |>
  Cubbystack_config<| tag == 'cubbystack_gnocchi' |> -> Service<| tag == 'cubbystack_gnocchi' |>

  # Restart gnocchi services whenever gnocchi.conf has been changed
  Cubbystack_config<| tag == 'cubbystack_gnocchi' |> ~> Service<| tag == 'cubbystack_gnocchi' |>
  Cubbystack_config<| tag == 'cubbystack_gnocchi' |> ~> Service['apache2']

  # Global file attributes
  File {
    ensure  => present,
    owner   => 'gnocchi',
    group   => 'gnocchi',
    mode    => '0640',
    tag     => $tags,
  }

  file { '/etc/gnocchi':
    ensure => directory,
  }

  # Gnocchi package
  vcsrepo { '/srv/gnocchi':
    ensure   => present,
    provider => git,
    revision => '4.2.4',
    owner    => 'gnocchi',
    group    => 'gnocchi',
    source   => 'https://github.com/gnocchixyz/gnocchi',
    notify   => Exec['install gnocchi'],
  }

  exec { 'install gnocchi':
    path        => ['/bin', '/usr/bin'],
    command     => 'pip install -e .[mysql,keystone]',
    cwd         => '/srv/gnocchi',
    refreshonly => true,
    notify      => Exec['create gnocchi.conf'],
    tag         => ['cubbystack_gnocchi_install'],
  }

  exec { 'create gnocchi.conf':
    path        => ['/bin', '/usr/bin', '/usr/local/bin'],
    command     => 'gnocchi-config-generator > /etc/gnocchi/gnocchi.conf',
    cwd         => '/srv/gnocchi',
    refreshonly => true,
    tag         => ['cubbystack_gnocchi_install', 'cubbystack_gnocchi_gnocchi.conf'],
  }

  file { '/etc/gnocchi/api-paste.ini':
    source  => '/srv/gnocchi/gnocchi/rest/api-paste.ini',
    replace => false,
    require => Exec['create gnocchi.conf'],
  }

  ## Configure gnocchi.conf
  $settings.each |$setting, $value| {
    cubbystack_config { "${config_file}: ${setting}":
      value => $value,
      tag   => $tags,
    }
  }

}
