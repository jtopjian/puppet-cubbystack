# == Class: cubbystack::cinder::volume
#
# Configures the cinder-volume package
#
# === Parameters
#
# [*package_ensure*]
#   The status of the cinder-volume package
#   Defaults to present
#
# [*service_enable*]
#   The status of the cinder-volume service
#   Defaults to true
#
# [*service_ensure*]
#   The run status of the cinder-volume service
#   Defaults to running
#
class cubbystack::cinder::volume (
  $package_ensure = present,
  $service_enable = true,
  $service_ensure = 'running'
) {

  cubbystack::functions::generic_service { 'cinder-volume':
    service_enable => $service_enable,
    service_ensure => $service_ensure,
    package_ensure => $package_ensure,
    package_name   => $::cubbystack::params::cinder_volume_package_name,
    service_name   => $::cubbystack::params::cinder_volume_service_name,
    tags           => $::cubbystack::cinder::tags,
  }

}
