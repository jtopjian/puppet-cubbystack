# == Class: cubbystack::neutron::dhcp
#
# Configures the neutron-dhcp
#
# === Parameters
#
# [*package_ensure*]
#   The status of the neutron-dhcp package
#   Defaults to latest
#
# [*service_enable*]
#   The status of the neutron-dhcp service
#   Defaults to true
#
# [*service_ensure*]
#   The run status of the neutron-dhcp service
#   Defaults to running
#
# [*settings*]
#   A hash of key => value settings to go in dhcp_agent.ini
#
# [*config_file*]
#   The path to dhcp_agent.ini
#   Defaults to /etc/neutron/dhcp_agent.ini
#
class cubbystack::neutron::dhcp (
  $settings,
  $package_ensure = latest,
  $service_enable = true,
  $service_ensure = true,
  $config_file    = '/etc/neutron/dhcp_agent.ini',
) {

  include ::cubbystack::params

  ## Meta settings and globals
  $tags = ['cubbystack_openstack', 'cubbystack_neutron', 'neutron-dhcp']

  # Make sure Neutron DHCP is installed before any configuration begins
  # Make sure Neutron DHCP is configured before the service starts
  Package<| tag == 'cubbystack_neutron' |> -> Cubbystack_config<| tag == 'neutron-dhcp' |>
  Package<| tag == 'cubbystack_neutron' |> -> File<| tag == 'neutron-dhcp' |>
  Cubbystack_config<| tag == 'neutron-dhcp' |> -> Service['neutron-dhcp']

  # Restart neutron-dhcp after any config changes
  Cubbystack_config<| tag == 'neutron-dhcp' |> ~> Service['neutron-dhcp']

  File {
    ensure => present,
    owner  => 'neutron',
    group  => 'neutron',
    mode   => '0640',
    tag    => $tags,
    notify => Service['neutron-dhcp'],
  }

  ## Neutron DHCP configuration
  file { $config_file: }

  # Configure the DHCP service
  $settings.each |$setting, $value| {
    cubbystack_config { "${config_file}: ${setting}":
      value => $value,
      tag   => $tags,
    }
  }

  cubbystack::functions::generic_service { 'neutron-dhcp':
    service_enable => $service_enable,
    service_ensure => $service_ensure,
    package_ensure => $package_ensure,
    package_name   => $::cubbystack::params::neutron_dhcp_package_name,
    service_name   => $::cubbystack::params::neutron_dhcp_service_name,
    tags           => $tags,
  }

}
