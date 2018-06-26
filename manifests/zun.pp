# == Class: cubbystack::zun
#
# Configures the zun package and zun.conf
#
# === Parameters
#
# [*settings*]
#   A hash of key => value settings to go in zun.conf
#
# [*package_ensure*]
#   The status of the zun package
#   Defaults to present
#
# [*config_file*]
#   The path to zun.conf
#   Defaults to /etc/zun/zun.conf
#
class cubbystack::zun (
  $settings,
  $package_ensure = present,
  $config_file    = '/etc/zun/zun.conf',
) {

  contain ::cubbystack::params

  ## Meta settings and globals
  $tags = ['cubbystack_openstack', 'cubbystack_zun']

  # Make sure zun is installed before configuration begins
  File<| tag == 'cubbystack_zun' |> -> Cubbystack_config<| tag == 'cubbystack_zun' |>
  Cubbystack_config<| tag == 'cubbystack_zun' |> -> Service<| tag == 'cubbystack_zun' |>

  # Restart zun services whenever zun.conf has been changed
  Cubbystack_config<| tag == 'cubbystack_zun' |> ~> Service<| tag == 'cubbystack_zun' |>

  # Global file attributes
  File {
    ensure  => present,
    owner   => 'zun',
    group   => 'zun',
    mode    => '0640',
    tag     => $tags,
  }

  file { '/etc/zun':
    ensure => directory,
  }

  # Zun package
  vcsrepo { '/srv/zun':
    ensure   => present,
    provider => git,
    owner    => 'zun',
    group    => 'zun',
    source   => 'https://github.com/openstack/zun/',
  }

  python::requirements { '/srv/zun/requirements.txt':
    require => Vcsrepo['/srv/zun'],
    notify  => Exec['install zun'],
  }

  exec { 'install zun':
    path        => ['/bin', '/usr/bin'],
    command     => 'python setup.py install',
    cwd         => '/srv/zun',
    refreshonly => true,
    notify      => Exec['create zun.conf'],
    tag         => ['cubbystack_zun_install'],
  }

  exec { 'create zun.conf':
    path        => ['/bin', '/usr/bin'],
    command     => 'oslo-config-generator --config-file etc/zun/zun-config-generator.conf',
    cwd         => '/srv/zun',
    refreshonly => true,
    tag         => ['cubbystack_zun_install', 'cubbystack_zun_zun.conf'],
  }

  file { '/etc/zun/zun.conf':
    source  => '/srv/zun/etc/zun/zun.conf.sample',
    replace => false,
    require => Exec['create zun.conf'],
  }

  file { '/etc/zun/api-paste.ini':
    source  => '/srv/zun/etc/zun/api-paste.ini',
    replace => false,
    require => Exec['create zun.conf'],
  }

  file { '/etc/zun/rootwrap.conf':
    source  => '/srv/zun/etc/zun/rootwrap.conf',
    replace => false,
    require => Exec['create zun.conf'],
  }

  file { '/etc/zun/rootwrap.d':
    source  => '/srv/zun/etc/zun/rootwrap.d',
    replace => false,
    recurse => true,
    require => Exec['create zun.conf'],
  }

  file { '/etc/sudoers.d/10_zun':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0440',
    content  => "zun ALL=(root) NOPASSWD: /usr/local/bin/zun-rootwrap /etc/zun/rootwrap.conf *\n",
  }

  ## Configure zun.conf
  $settings.each |$setting, $value| {
    cubbystack_config { "${config_file}: ${setting}":
      value => $value,
      tag   => $tags,
    }
  }

}
