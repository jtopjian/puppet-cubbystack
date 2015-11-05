# == Class: cubbystack::heat::api
#
# Configures the heat-api package and service
#
# === Parameters
#
# [*package_ensure*]
#   The status of the heat-api package
#   Defaults to latest
#
# [*service_enable*]
#   The status of the heat-api service
#   Defaults to true
#
class cubbystack::heat::api (
  $package_ensure = latest,
  $service_enable = true
) {

  include ::cubbystack::heat

  cubbystack::functions::generic_service { 'heat-api':
    service_enable => $service_enable,
    package_ensure => $package_ensure,
    package_name   => $::cubbystack::params::heat_api_package_name,
    service_name   => $::cubbystack::params::heat_api_service_name,
    tags           => $::cubbystack::heat::tags,
  }

}
