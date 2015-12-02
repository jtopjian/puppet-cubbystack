# == Class: cubbystack::neutron::server
#
# Configures the neutron-server
#
# === Parameters
#
# [*package_ensure*]
#   The status of the neutron-server package
#   Defaults to latest
#
# [*service_enable*]
#   The status of the neutron-server service
#   Defaults to true
#
class cubbystack::neutron::server (
  $package_ensure = latest,
  $service_enable = true
) {

  cubbystack::functions::generic_service { 'neutron-server':
    service_enable => $service_enable,
    package_ensure => $package_ensure,
    package_name   => $::cubbystack::params::neutron_server_package_name,
    service_name   => $::cubbystack::params::neutron_server_service_name,
    tags           => $::cubbystack::neutron::tags,
  }

}
