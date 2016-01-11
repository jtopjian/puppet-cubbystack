# == Class: cubbystack::designate::pool-manager
#
# Configures the designate-pool-manager package and service
#
# === Parameters
#
# [*package_ensure*]
#   The status of the designate-pool-manager package
#   Defaults to latest
#
# [*service_enable*]
#   The status of the designate-pool-manager service
#   Defaults to true
#
# [*install_service*]
#   Whether or not to install/enable designate-pool-manager
#   Defaults to true
#
# === Example Usage
#
# Please see the `examples` directory.
#
class cubbystack::designate::pool-manager (
  $package_ensure   = latest,
  $service_enable   = true,
  $install_service  = true,
) {

  include ::cubbystack::designate

  if ($install_service) {
    cubbystack::functions::generic_service { 'designate-pool-manager':
      service_enable => $service_enable,
      package_ensure => $package_ensure,
      package_name   => $::cubbystack::params::designate_pool_manager_package_name,
      service_name   => $::cubbystack::params::designate_pool_manager_service_name,
      tags           => $::cubbystack::designate::tags,
    }
  }

}
