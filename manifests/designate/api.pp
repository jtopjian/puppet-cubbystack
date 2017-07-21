# == Class: cubbystack::designate::api
#
# Configures the designate-api package and service
#
# === Parameters
#
# [*package_ensure*]
#   The status of the designate-api package
#   Defaults to latest
#
# [*service_enable*]
#   The status of the designate-api service
#   Defaults to true
#
# [*service_ensure*]
#   The run status of the designate-api service
#   Defaults to running
#
class cubbystack::designate::api (
  $package_ensure  = latest,
  $service_enable  = true,
  $service_ensure  = 'running',
) {

  include ::cubbystack::designate

  cubbystack::functions::generic_service { 'designate-api':
    service_enable => $service_enable,
    service_ensure => $service_ensure,
    package_ensure => $package_ensure,
    package_name   => $::cubbystack::params::designate_api_package_name,
    service_name   => $::cubbystack::params::designate_api_service_name,
    tags           => $::cubbystack::designate::tags,
  }

}
