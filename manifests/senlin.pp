# == Class: cubbystack::senlin
#
# Configures the senlin package and senlin.conf
#
# === Parameters
#
# [*settings*]
#   A hash of key => value settings to go in senlin.conf
#
# [*version*]
#   The version of senlin to install
#   Defaults to master
#
# [*config_file*]
#   The path to senlin.conf
#   Defaults to /etc/senlin/senlin.conf
#
class cubbystack::senlin (
  $settings,
  $version     = 'master',
  $config_file = '/etc/senlin/senlin.conf',
) {

  contain ::cubbystack::params

  ## Meta settings and globals
  $tags = ['cubbystack_openstack', 'cubbystack_senlin']

  # Make sure senlin is installed before configuration begins
  File<| tag == 'cubbystack_senlin' |> -> Cubbystack_config<| tag == 'cubbystack_senlin' |>
  Cubbystack_config<| tag == 'cubbystack_senlin' |> -> Service<| tag == 'cubbystack_senlin' |>

  # Restart senlin services whenever senlin.conf has been changed
  Cubbystack_config<| tag == 'cubbystack_senlin' |> ~> Service<| tag == 'cubbystack_senlin' |>

  # Global file attributes
  File {
    ensure  => present,
    owner   => 'senlin',
    group   => 'senlin',
    mode    => '0640',
    tag     => $tags,
  }

  file { '/etc/senlin':
    ensure => directory,
  }

  # Senlin package
  vcsrepo { '/srv/senlin':
    ensure   => present,
    provider => git,
    revision => $version,
    owner    => 'senlin',
    group    => 'senlin',
    source   => 'https://github.com/openstack/senlin/',
    notify   => Exec['install senlin'],
  }

  exec { 'install senlin':
    path        => ['/bin', '/usr/bin'],
    command     => 'pip install -e .',
    cwd         => '/srv/senlin',
    refreshonly => true,
    notify      => Exec['create senlin.conf'],
    tag         => ['cubbystack_senlin_install'],
  }

  exec { 'create senlin.conf':
    path        => ['/bin', '/usr/bin'],
    command     => '/srv/senlin/tools/gen-config',
    cwd         => '/srv/senlin',
    refreshonly => true,
    tag         => ['cubbystack_senlin_install', 'cubbystack_senlin_senlin.conf'],
  }

  file { '/etc/senlin/senlin.conf':
    source  => '/srv/senlin/etc/senlin/senlin.conf.sample',
    replace => false,
    require => Exec['create senlin.conf'],
  }

  file { '/etc/senlin/api-paste.ini':
    source  => '/srv/senlin/etc/senlin/api-paste.ini',
    replace => false,
    require => Exec['create senlin.conf'],
  }

  ## Configure senlin.conf
  $settings.each |$setting, $value| {
    cubbystack_config { "${config_file}: ${setting}":
      value => $value,
      tag   => $tags,
    }
  }

}
