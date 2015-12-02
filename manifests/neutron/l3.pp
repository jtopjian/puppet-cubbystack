# == Class: cubbystack::neutron::l3
#
# Configures the neutron-l3
#
# === Parameters
#
# [*package_ensure*]
#   The status of the neutron-l3 package
#   Defaults to latest
#
# [*service_enable*]
#   The status of the neutron-l3 service
#   Defaults to true
#
# [*settings*]
#   A hash of key => value settings to go in l3_agent.ini
#
# [*config_file*]
#   The path to l3_agent.ini
#   Defaults to /etc/neutron/l3_agent.ini
#
class cubbystack::neutron::l3 (
  $settings,
  $package_ensure = latest,
  $service_enable = true,
  $config_file    = '/etc/neutron/l3_agent.ini',
) {

  include ::cubbystack::params

  ## Meta settings and globals
  $tags = ['openstack', 'neutron', 'neutron-l3']

  # Make sure Neutron L3 is installed before any configuration begins
  # Make sure Neutron L3 is configured before the service starts
  Package<| tag == 'neutron' |> -> Cubbystack_config<| tag == 'neutron-l3' |>
  Package<| tag == 'neutron' |> -> File<| tag == 'neutron-l3' |>
  Cubbystack_config<| tag == 'neutron-l3' |> -> Service['neutron-l3']

  # Restart neutron-l3 after any config changes
  Cubbystack_config<| tag == 'neutron-l3' |> ~> Service['neutron-l3']

  File {
    ensure => present,
    owner  => 'neutron',
    group  => 'neutron',
    mode   => '0640',
    tag    => $tags,
    notify => Service['neutron-l3'],
  }

  ## Neutron L3 configuration
  file { $config_file: }

  # Configure the L3 service
  $settings.each |$setting, $value| {
    cubbystack_config { "${config_file}: ${setting}":
      value => $value,
      tag   => $tags,
    }
  }

  cubbystack::functions::generic_service { 'neutron-l3':
    service_enable => $service_enable,
    package_ensure => $package_ensure,
    package_name   => $::cubbystack::params::neutron_l3_package_name,
    service_name   => $::cubbystack::params::neutron_l3_service_name,
    tags           => $tags,
  }

}
