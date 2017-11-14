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
# [*service_ensure*]
#   The run status of the neutron-plugin-ovs service
#   Defaults to running
#
class cubbystack::neutron::plugins::ovs (
  $package_ensure = latest,
  $service_enable = true,
  $service_ensure = 'running',
) {

  include ::cubbystack::params

  ## Meta settings and globals
  $tags = ['cubbystack_openstack', 'cubbystack_neutron', 'neutron-plugin-ovs']

  cubbystack::functions::generic_service { 'neutron-plugin-ovs':
    service_enable => $service_enable,
    service_ensure => $service_ensure,
    package_ensure => $package_ensure,
    package_name   => $::cubbystack::params::neutron_plugin_ovs_package_name,
    service_name   => $::cubbystack::params::neutron_plugin_ovs_service_name,
    tags           => $tags,
  }

}
