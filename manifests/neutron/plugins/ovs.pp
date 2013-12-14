# == Class: cubbystack::neutron::plugins::ovs
#
# Configures the neutron-plugin-ovs
#
# === Parameters
#
# [*package_ensure*]
#   The status of the neutron-plugin-ovs package
#   Defaults to latest
#
# [*service_enable*]
#   The status of the neutron-plugin-ovs service
#   Defaults to true
#
# [*settings*]
#   A hash of key => value settings to go in ovs_neutron_plugin.ini
#
# [*config_file*]
#   The path to ovs_agent.ini
#   Defaults to /etc/neutron/plugins/openvswitch/ovs_neutron_plugin.ini
#
# === Example Usage
#
# Please see the `examples` directory.
#
class cubbystack::neutron::ovs (
  $settings,
  $package_ensure = latest,
  $service_enable = true,
  $config_file    = '/etc/neutron/plugins/openvswitch/ovs_neutron_plugin.ini',
) {

  include ::cubbystack::params

  ## Meta settings and globals
  $tags = ['openstack', 'neutron', 'neutron-plugin-ovs']

  # Make sure Neutron Open vSwitch is installed before any configuration begins
  # Make sure Neutron Open vSwitch is configured before the service starts
  Package['neutron-plugin-ovs'] -> Cubbystack_config<| tag == 'neutron-plugin-ovs' |>
  Cubbystack_config<| tag == 'neutron-plugin-ovs' |> -> Service['neutron-plugin-ovs']

  # Restart neutron-plugin-ovs after any config changes
  Cubbystack_config<| tag == 'neutron-plugin-ovs' |> ~> Service['neutron-plugin-ovs']

  File {
    ensure  => present,
    owner   => 'neutron',
    group   => 'neutron',
    mode    => '0640',
    tag     => $tags,
    notify  => Service['neutron-plugin-ovs'],
    require => Package['neutron-plugin-ovs'],
  }

  ## Neutron Open vSwitch configuration
  file { $config_file: }

  # Configure the Open vSwitch service
  $settings.each { |$setting, $value|
    cubbystack_config { "${config_file}: ${setting}":
      value => $value,
      tag   => $tags,
    }
  }

  cubbystack::functions::generic_service { 'neutron-plugin-ovs':
    service_enable => $service_enable,
    package_ensure => $package_ensure,
    package_name   => $::cubbystack::params::neutron_ovs_package_name,
    service_name   => $::cubbystack::params::neutron_ovs_service_name,
    tags           => $tags,
  }

}
