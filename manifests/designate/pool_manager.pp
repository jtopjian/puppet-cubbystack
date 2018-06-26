# == Class: cubbystack::designate::pool-manager
#
# Configures the designate-pool-manager package and service
#
# === Parameters
#
# [*package_ensure*]
#   The status of the designate-pool-manager package
#   Defaults to present
#
# [*service_enable*]
#   The status of the designate-pool-manager service
#   Defaults to true
#
# [*service_ensure*]
#   The status of the designate-pool-manager service
#   Defaults to running
#
class cubbystack::designate::pool-manager (
  $package_ensure = present,
  $service_enable = true,
  $service_ensure = 'running',
) {

  contain ::cubbystack::designate

  cubbystack::functions::generic_service { 'designate-pool-manager':
    service_enable => $service_enable,
    service_ensure => $service_ensure,
    package_ensure => $package_ensure,
    package_name   => $::cubbystack::params::designate_pool_manager_package_name,
    service_name   => $::cubbystack::params::designate_pool_manager_service_name,
    tags           => $::cubbystack::designate::tags,
  }

}
