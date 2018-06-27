# == Class: cubbystack::magnum
#
# Configures the magnum-common package and magnum.conf
#
# === Parameters
#
# [*settings*]
#   A hash of key => value settings to go in magnum.conf
#
# [*config_file*]
#   The path to magnum.conf
#   Defaults to /etc/magnum/magnum.conf
#
# [*package_ensure*]
#   The status of the magnum-common package
#   Defaults to present
#
class cubbystack::magnum (
  $settings,
  $package_ensure = present,
  $config_file    = '/etc/magnum/magnum.conf',
) {

  include ::cubbystack::params

  ## Meta settings and globals
  $tags = ['cubbystack_openstack', 'cubbystack_magnum']

  # Make sure magnum is installed before configuration begins
  Package<| tag == 'cubbystack_magnum' |> -> Cubbystack_config<| tag == 'cubbystack_magnum' |>
  Cubbystack_config<| tag == 'cubbystack_magnum' |> -> Service<| tag == 'cubbystack_magnum' |>

  # Restart magnum services whenever magnum.conf has been changed
  Cubbystack_config<| tag == 'cubbystack_magnum' |> ~> Service<| tag == 'cubbystack_magnum' |>

  # Global file attributes
  File {
    ensure  => present,
    owner   => 'magnum',
    group   => 'magnum',
    mode    => '0640',
    tag     => $tags,
    require => Package['magnum-common'],
  }

  # magnum-common package
  package { 'magnum-common':
    ensure => $package_ensure,
    name   => $::cubbystack::params::magnum_common_package_name,
    tag    => $tags,
  }

  ## Magnum configuration files
  file { '/etc/magnum':
    ensure  => directory,
    recurse => true,
  }

  file { '/var/log/magnum': ensure => directory }
  file { $config_file: }

  # Configure magnum.conf
  $settings.each |$setting, $value| {
    cubbystack_config { "${config_file}: ${setting}":
      value => $value,
      tag   => $tags,
    }
  }

}
