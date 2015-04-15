# == Class: cubbystack::neutron::plugins::linuxbridge
#
# Configures the neutron-plugin-linuxbridge
#
# === Parameters
#
# [*package_ensure*]
#   The status of the neutron-plugin-linuxbridge package
#   Defaults to present
#
# [*service_enable*]
#   The status of the neutron-plugin-linuxbridge service
#   Defaults to true
#
class cubbystack::neutron::plugins::linuxbridge (
  $package_ensure = present,
  $service_enable = true,
) {

  include ::cubbystack::params

  ## Meta settings and globals
  $tags = ['openstack', 'neutron', 'neutron-plugin-linuxbridge']

  file { '/etc/init/neutron-plugin-linuxbridge-agent.conf':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => 'puppet:///modules/cubbystack/neutron/neutron-plugin-linuxbridge-agent.conf',
    tag     => $tags,
    notify  => Service[$::cubbystack::params::neutron_plugin_linuxbridge_service_name],
    require => Package[$::cubbystack::params::neutron_plugin_linuxbridge_package_name],
  }

  cubbystack::functions::generic_service { 'neutron-plugin-linuxbridge':
    service_enable => $service_enable,
    package_ensure => $package_ensure,
    package_name   => $::cubbystack::params::neutron_plugin_linuxbridge_package_name,
    service_name   => $::cubbystack::params::neutron_plugin_linuxbridge_service_name,
    tags           => $tags,
  }

}
