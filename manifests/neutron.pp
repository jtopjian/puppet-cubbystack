# == Class: cubbystack::neutron
#
# Configures the neutron-common package and neutron.conf
#
# === Parameters
#
# [*settings*]
#   A hash of key => value settings to go in neutron.conf
#
# [*config_file*]
#   The path to neutron.conf
#   Defaults to /etc/neutron/neutron.conf
#
# [*package_ensure*]
#   The status of the neutron-common package
#   Defaults to latest
#
# === Example Usage
#
# Please see the `examples` directory.
#
class cubbystack::neutron (
  $settings,
  $package_ensure = latest,
  $config_file    = '/etc/neutron/neutron.conf',
) {

  include ::cubbystack::params

  ## Meta settings and globals
  $tags = ['openstack', 'neutron']

  # Make sure neutron is installed before configuration begins
  Package<| tag == 'neutron' |> -> Cubbystack_config<| tag == 'neutron' |>
  Cubbystack_config<| tag == 'neutron' |> -> Service<| tag == 'neutron' |>

  # Restart neutron services whenever neutron.conf has been changed
  Cubbystack_config<| tag == 'neutron' |> ~> Service<| tag == 'neutron' |>

  # Global file attributes
  File {
    ensure  => present,
    owner   => 'neutron',
    group   => 'neutron',
    mode    => '0640',
    tag     => $tags,
    require => Package['neutron-common'],
  }

  # neutron-common package
  package { 'neutron-common':
    name   => $::cubbystack::params::neutron_common_package_name,
    ensure => present,
    tag    => $tags,
  }

  ## Neutron configuration files
  file {
    '/var/log/neutron':
      ensure  => directory,
      recurse => true;
    '/etc/neutron':
      ensure  => directory,
      recurse => true;
  }

  # Configure neutron.conf
  $settings.each |$setting, $value| {
    cubbystack_config { "${config_file}: ${setting}":
      value => $value,
      tag   => $tags,
    }
  }

}
