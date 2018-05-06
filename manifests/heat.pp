# == Class: cubbystack::heat
#
# Configures the heat-common package and heat.conf
#
# === Parameters
#
# [*settings*]
#   A hash of key => value settings to go in cinder.conf
#
# [*package_ensure*]
#   The status of the heat-common package
#   Defaults to present
#
# [*config_file*]
#   The path to heat.conf
#   Defaults to /etc/heat/heat.conf
#
class cubbystack::heat (
  $settings,
  $package_ensure = present,
  $config_file    = '/etc/heat/heat.conf',
) {

  include ::cubbystack::params

  ## Meta settings and globals
  $tags = ['cubbystack_openstack', 'cubbystack_heat']

  # Make sure heat is installed before configuration begins
  Package<| tag == 'cubbystack_heat' |> -> Cubbystack_config<| tag == 'cubbystack_heat' |>
  Cubbystack_config<| tag == 'cubbystack_heat' |> -> Service<| tag == 'cubbystack_heat' |>

  # Restart heat services whenever heat.conf has been changed
  Cubbystack_config<| tag == 'cubbystack_heat' |> ~> Service<| tag == 'cubbystack_heat' |>

  # Global file attributes
  File {
    ensure  => present,
    owner   => 'heat',
    group   => 'heat',
    mode    => '0640',
    tag     => $tags,
    require => Package['heat-common'],
  }

  # heat-common package
  package { 'heat-common':
    ensure => present,
    name   => $::cubbystack::params::heat_common_package_name,
    tag    => $tags,
  }

  ## Nova configuration files
  file { '/var/log/heat':
    ensure  => directory,
    recurse => true,
  }

  file { '/etc/heat':
    ensure  => directory,
    recurse => true,
  }

  file { $config_file: }

  ## Configure heat.conf
  $settings.each |$setting, $value| {
    cubbystack_config { "${config_file}: ${setting}":
      value => $value,
      tag   => $tags,
    }
  }

}
