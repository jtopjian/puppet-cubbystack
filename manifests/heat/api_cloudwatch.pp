# == Class: cubbystack::heat::api_cloudwatch
#
# Configures the heat-api_cloudwatch package and service
#
# === Parameters
#
# [*package_ensure*]
#   The status of the heat-api_cloudwatch package
#   Defaults to present
#
# [*service_enable*]
#   The status of the heat-api_cloudwatch service
#   Defaults to true
#
class cubbystack::heat::api_cloudwatch (
  $package_ensure = present,
  $service_enable = true
) {

  include ::cubbystack::heat

  cubbystack::functions::generic_service { 'heat-api_cloudwatch':
    service_enable => $service_enable,
    package_ensure => $package_ensure,
    package_name   => $::cubbystack::params::heat_api_cloudwatch_package_name,
    service_name   => $::cubbystack::params::heat_api_cloudwatch_service_name,
    tags           => $::cubbystack::heat::tags,
  }

}
