# == Class: cubbystack::designate
#
# Configures the designate-common package and designate.conf
#
# === Parameters
#
# [*settings*]
#   A hash of key => value settings to go in designate.conf
#
# [*yaml_settings*]
#   A hash of key => value settings to go in pools.yaml
#
# [*config_file*]
#   The path to designate.conf
#   Defaults to /etc/designate/designate.conf
#
# [*yaml_config_file*]
#   The path to pools.yaml
#   Defaults to /etc/designate/pools.yaml
#
# [*package_ensure*]
#   The status of the designate-common package
#   Defaults to present
#
# === Example Usage
#
# Please see the `examples` directory.
#
class cubbystack::designate (
  $settings,
  $package_ensure   = present,
  $config_file      = '/etc/designate/designate.conf',
) {

  include ::cubbystack::params

  ## Meta settings and globals
  $tags = ['openstack', 'cubbystack_designate']

  # Make sure designate is installed before configuration begins
  Package<| tag == 'cubbystack_designate' |>           -> Cubbystack_config<| tag == 'cubbystack_designate' |>
  Cubbystack_config<| tag == 'cubbystack_designate' |> -> Service<| tag == 'cubbystack_designate' |>

  # Restart designate services whenever designate.conf has been changed
  Cubbystack_config<| tag == 'cubbystack_designate' |> ~> Service<| tag == 'cubbystack_designate' |>

  # Global file attributes
  File {
    ensure  => present,
    owner   => 'designate',
    group   => 'designate',
    mode    => '0640',
    tag     => $tags,
    require => Package['designate-common'],
  }

  # designate-common package
  package { 'designate-common':
    name   => $::cubbystack::params::designate_common_package_name,
    ensure => present,
    tag    => $tags,
  }

  ## Designate configuration files
  file { '/etc/designate':
    ensure  => directory,
    recurse => true,
  }

  file { '/var/log/designate': ensure => directory }
  file { $config_file: }

  # Configure designate.conf
  $settings.each |$setting, $value| {
    cubbystack_config { "${config_file}: ${setting}":
      value => $value,
      tag   => $tags,
    }
  }
}
