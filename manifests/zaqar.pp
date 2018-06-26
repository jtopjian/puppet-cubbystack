# == Class: cubbystack::zaqar
#
# Configures the zaqar-common package and zaqar.conf
#
# === Parameters
#
# [*settings*]
#   A hash of key => value settings to go in zaqar.conf
#
# [*config_file*]
#   The path to zaqar.conf
#   Defaults to /etc/zaqar/zaqar.conf
#
# [*package_ensure*]
#   The status of the zaqar-common package
#   Defaults to present
#
class cubbystack::zaqar (
  $settings,
  $package_ensure = present,
  $config_file    = '/etc/zaqar/zaqar.conf',
) {

  contain ::cubbystack::params

  ## Meta settings and globals
  $tags = ['cubbystack_openstack', 'cubbystack_zaqar']

  # Make sure zaqar is installed before configuration begins
  Package<| tag == 'cubbystack_zaqar' |> -> Cubbystack_config<| tag == 'cubbystack_zaqar' |>
  Cubbystack_config<| tag == 'cubbystack_zaqar' |> -> Service<| tag == 'cubbystack_zaqar' |>

  # Restart zaqar services whenever zaqar.conf has been changed
  Cubbystack_config<| tag == 'cubbystack_zaqar' |> ~> Service<| tag == 'cubbystack_zaqar' |>

  # Global file attributes
  File {
    ensure  => present,
    owner   => 'zaqar',
    group   => 'zaqar',
    mode    => '0640',
    tag     => $tags,
    require => Package['zaqar-common'],
  }

  # zaqar-common package
  package { 'zaqar-common':
    ensure => $package_ensure,
    name   => $::cubbystack::params::zaqar_common_package_name,
    tag    => $tags,
  }

  ## Zaqar configuration files
  file { '/etc/zaqar':
    ensure  => directory,
    recurse => true,
  }

  file { '/var/log/zaqar': ensure => directory }
  file { $config_file: }

  # Configure zaqar.conf
  $settings.each |$setting, $value| {
    cubbystack_config { "${config_file}: ${setting}":
      value => $value,
      tag   => $tags,
    }
  }

}
