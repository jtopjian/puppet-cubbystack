# == Class: cubbystack::cinder::api
#
# Configures the cinder-api
#
# === Parameters
#
# [*package_ensure*]
#   The status of the cinder-api package
#   Defaults to latest
#
# [*service_enable*]
#   The status of the cinder-api service
#   Defaults to true
#
# [*service_ensure*]
#   The run status of the cinder-api service
#   Defaults to running
#
class cubbystack::cinder::api (
  $package_ensure = latest,
  $service_enable = true,
  $service_ensure = 'running'
) {

  cubbystack::functions::generic_service { 'cinder-api':
    service_enable => $service_enable,
    service_ensure => $service_ensure,
    package_ensure => $package_ensure,
    package_name   => $::cubbystack::params::cinder_api_package_name,
    service_name   => $::cubbystack::params::cinder_api_service_name,
    tags           => $::cubbystack::cinder::tags,
  }

}
