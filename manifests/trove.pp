# == Class: cubbystack::trove
#
# Configures the trove-common package and trove.conf
#
# === Parameters
#
# [*settings*]
#   A hash of key => value settings to go in cinder.conf
#
# [*package_ensure*]
#   The status of the trove-common package
#   Defaults to present
#
# [*config_file*]
#   The path to trove.conf
#   Defaults to /etc/trove/trove.conf
#
class cubbystack::trove (
  $settings,
  $package_ensure = present,
  $config_file    = '/etc/trove/trove.conf',
) {

  include ::cubbystack::params

  ## Meta settings and globals
  $tags = ['cubbystack_openstack', 'cubbystack_trove']

  # Make sure trove is installed before configuration begins
  Package<| tag == 'cubbystack_trove' |> -> Cubbystack_config<| tag == 'cubbystack_trove' |>
  Cubbystack_config<| tag == 'cubbystack_trove' |> -> Service<| tag == 'cubbystack_trove' |>

  # Restart trove services whenever trove.conf has been changed
  Cubbystack_config<| tag == 'cubbystack_trove' |> ~> Service<| tag == 'cubbystack_trove' |>

  # Global file attributes
  File {
    ensure  => present,
    owner   => 'trove',
    group   => 'trove',
    mode    => '0640',
    tag     => $tags,
    require => Package['trove-common'],
  }

  # trove-common package
  package { 'trove-common':
    ensure => present,
    name   => $::cubbystack::params::trove_common_package_name,
    tag    => $tags,
  }

  ## Nova configuration files
  file { '/var/log/trove':
    ensure  => directory,
    recurse => true,
  }

  file { '/etc/trove':
    ensure  => directory,
    recurse => true,
  }

  file { '/etc/trove/cloudinit':
    ensure  => directory,
    recurse => true,
  }

  file { $config_file: }

  ## Configure trove.conf
  $settings.each |$setting, $value| {
    cubbystack_config { "${config_file}: ${setting}":
      value => $value,
      tag   => $tags,
    }
  }

}
