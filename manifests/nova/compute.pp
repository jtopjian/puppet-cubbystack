# == Class: cubbystack::nova::compute
#
# Configures the nova-compute package and service
#
# === Parameters
#
# [*package_ensure*]
#   The status of the nova-compute package
#   Defaults to latest
#
# [*service_enable*]
#   The status of the nova-compute service
#   Defaults to true
#
# [*service_ensure*]
#   The run status of the nova-compute service
#   Defaults to running
#
class cubbystack::nova::compute (
  $package_ensure = latest,
  $service_enable = true,
  $service_ensure = 'running',
) {

  contain ::cubbystack::nova

  cubbystack::functions::generic_service { 'nova-compute':
    service_enable => $service_enable,
    service_ensure => $service_ensure,
    package_ensure => $package_ensure,
    package_name   => $::cubbystack::params::nova_compute_package_name,
    service_name   => $::cubbystack::params::nova_compute_service_name,
    tags           => $::cubbystack::nova::tags,
  }

}
