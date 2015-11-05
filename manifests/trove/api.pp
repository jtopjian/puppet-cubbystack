# == Class: cubbystack::trove::api
#
# Configures the trove-api package and service
#
# === Parameters
#
# [*package_ensure*]
#   The status of the trove-api package
#   Defaults to latest
#
# [*service_enable*]
#   The status of the trove-api service
#   Defaults to true
#
class cubbystack::trove::api (
  $package_ensure = latest,
  $service_enable = true
) {

  include ::cubbystack::trove

  cubbystack::functions::generic_service { 'trove-api':
    service_enable => $service_enable,
    package_ensure => $package_ensure,
    package_name   => $::cubbystack::params::trove_api_package_name,
    service_name   => $::cubbystack::params::trove_api_service_name,
    tags           => $::cubbystack::trove::tags,
  }

}
