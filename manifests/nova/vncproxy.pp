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
# === Example Usage
#
# Please see the `examples` directory.
#
class cubbystack::nova::vncproxy (
  $package_ensure = latest,
  $service_enable = true
) {

  include ::cubbystack::params
  include ::cubbystack::nova

  if $::cubbystack::params::nova_novnc_package_name {
    package { $::cubbystack::params::nova_novnc_package_name:
      ensure => $package_ensure,
    }
  }

  cubbystack::functions::generic_service { 'nova-vncproxy':
    service_enable => $service_enable,
    package_ensure => $package_ensure,
    package_name   => $::cubbystack::params::nova_vncproxy_package_name,
    service_name   => $::cubbystack::params::nova_vncproxy_service_name,
    tags           => $::cubbystack::nova::tags,
  }

}
