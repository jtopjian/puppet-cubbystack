# == Class: cubbystack::designate::zone_manager
#
# Configures the designate-zone-manager package and service
#
# === Parameters
#
# [*package_ensure*]
#   The status of the designate-zone-manager package
#   Defaults to latest
#
# [*service_enable*]
#   The status of the designate-zone-manager service
#   Defaults to true
#
# [*service_ensure*]
#   The run status of the designate-zone-manager service
#   Defaults to running
#
class cubbystack::designate::zone_manager (
  $package_ensure = latest,
  $service_enable = true,
  $service_ensure = 'running',
) {

  include ::cubbystack::designate

  cubbystack::functions::generic_service { 'designate-zone-manager':
    service_enable => $service_enable,
    service_ensure => $service_ensure,
    package_ensure => $package_ensure,
    package_name   => $::cubbystack::params::designate_zone_manager_package_name,
    service_name   => $::cubbystack::params::designate_zone_manager_service_name,
    tags           => $::cubbystack::designate::tags,
  }

}
