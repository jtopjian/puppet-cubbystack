# == Class: cubbystack::cinder::volume
#
# Configures the cinder-volume package
#
# === Parameters
#
# [*package_ensure*]
#   The status of the cinder-volume package
#   Defaults to latest
#
# [*service_enable*]
#   The status of the cinder-volume service
#   Defaults to true
#
class cubbystack::cinder::volume (
  $package_ensure = latest,
  $service_enable = true
) {

  cubbystack::functions::generic_service { 'cinder-volume':
    service_enable => $service_enable,
    package_ensure => $package_ensure,
    package_name   => $::cubbystack::params::cinder_volume_package_name,
    service_name   => $::cubbystack::params::cinder_volume_service_name,
    tags           => $::cubbystack::cinder::tags,
  }

}
