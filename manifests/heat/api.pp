# == Class: cubbystack::heat::api
#
# Configures the heat-api package and service
#
# === Parameters
#
# [*package_ensure*]
#   The status of the heat-api package
#   Defaults to present
#
# [*service_enable*]
#   The status of the heat-api service
#   Defaults to true
#
# [*service_ensure*]
#   The run status of the heat-api service
#   Defaults to running
#
class cubbystack::heat::api (
  $package_ensure = present,
  $service_enable = true,
  $service_ensure = 'running'
) {

  contain ::cubbystack::heat

  cubbystack::functions::generic_service { 'heat-api':
    service_enable => $service_enable,
    service_ensure => $service_ensure,
    package_ensure => $package_ensure,
    package_name   => $::cubbystack::params::heat_api_package_name,
    service_name   => $::cubbystack::params::heat_api_service_name,
    tags           => $::cubbystack::heat::tags,
  }

}
