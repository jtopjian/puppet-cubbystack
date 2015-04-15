# == Class: cubbystack::cinder::api
#
# Configures the cinder-api
#
# === Parameters
#
# [*package_ensure*]
#   The status of the cinder-api package
#   Defaults to present
#
# [*service_enable*]
#   The status of the cinder-api service
#   Defaults to true
#
class cubbystack::cinder::api (
  $package_ensure = present,
  $service_enable = true
) {

  cubbystack::functions::generic_service { 'cinder-api':
    service_enable => $service_enable,
    package_ensure => $package_ensure,
    package_name   => $::cubbystack::params::cinder_api_package_name,
    service_name   => $::cubbystack::params::cinder_api_service_name,
    tags           => $::cubbystack::cinder::tags,
  }

}
