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
class cubbystack::neutron::plugins::ovs (
  $settings,
  $package_ensure = latest,
  $service_enable = true,
  $config_file    = '/etc/neutron/plugins/openvswitch/ovs_neutron_plugin.ini',
) {

  include ::cubbystack::params

  ## Meta settings and globals
  $tags = ['openstack', 'neutron', 'neutron-plugin-ovs']

  # Make sure Neutron is installed before any configuration begins
  # Make sure Neutron is configured before the service starts
  Package<| tag == 'neutron' |> -> Cubbystack_config<| tag == 'neutron-plugin-ovs' |>
  Package<| tag == 'neutron' |> -> File<| tag == 'neutron-plugin-ovs' |>
  Cubbystack_config<| tag == 'neutron-plugin-ovs' |> -> Service['neutron-plugin-ovs']

  # Restart neutron-plugin-ovs after any config changes
  Cubbystack_config<| tag == 'neutron-plugin-ovs' |> ~> Service['neutron-plugin-ovs']

  File {
    ensure  => present,
    owner   => 'neutron',
    group   => 'neutron',
    mode    => '0640',
    tag     => $tags,
    require => Package['neutron-plugin-ovs'],
    notify  => Service['neutron-plugin-ovs'],
  }

  ## Neutron Open vSwitch configuration
  file { $config_file: }

  # This is for RH-based distros
  # But it won't hurt to have for all distros
  file { '/etc/neutron/plugin.ini':
    ensure => link,
    target => $config_file,
  }

  # Configure the Open vSwitch service
  $settings.each |$setting, $value| {
    cubbystack_config { "${config_file}: ${setting}":
      value => $value,
      tag   => $tags,
    }
  }

  cubbystack::functions::generic_service { 'neutron-plugin-ovs':
    service_enable => $service_enable,
    package_ensure => $package_ensure,
    package_name   => $::cubbystack::params::neutron_plugin_ovs_package_name,
    service_name   => $::cubbystack::params::neutron_plugin_ovs_service_name,
    tags           => $tags,
  }

}
