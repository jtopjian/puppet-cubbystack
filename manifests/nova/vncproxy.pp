# == Class: cubbystack::nova::vncproxy
#
# Configures the nova-vncproxy package and service
#
# === Parameters
#
# [*package_ensure*]
#   The status of the nova-vncproxy package
#   Defaults to latest
#
# [*service_enable*]
#   The status of the nova-vncproxy service
#   Defaults to true
#
# [*service_ensure*]
#   The run status of the nova-vncproxy service
#   Defaults to running
#
class cubbystack::nova::vncproxy (
  $package_ensure = latest,
  $service_enable = true,
  $service_ensure = 'running'
) {

  contain ::cubbystack::params
  contain ::cubbystack::nova

  if $::cubbystack::params::nova_novnc_package_name {
    package { $::cubbystack::params::nova_novnc_package_name:
      ensure => $package_ensure,
    }
  }

  cubbystack::functions::generic_service { 'nova-vncproxy':
    service_enable => $service_enable,
    service_ensure => $service_ensure,
    package_ensure => $package_ensure,
    package_name   => $::cubbystack::params::nova_vncproxy_package_name,
    service_name   => $::cubbystack::params::nova_vncproxy_service_name,
    tags           => $::cubbystack::nova::tags,
  }

}
