# == Class: cubbystack::sahara::api
#
# Configures the sahara-api package and service
#
# === Parameters
#
# [*package_ensure*]
#   The status of the sahara-api package
#   Defaults to latest
#
# [*service_enable*]
#   The status of the sahara-registry service
#   Defaults to true
#
class cubbystack::sahara::api (
  $package_ensure = latest,
  $service_enable = true,
) {

  include ::cubbystack::sahara

  cubbystack::functions::generic_service { 'sahara-api':
    service_enable => $service_enable,
    package_ensure => $package_ensure,
    package_name   => $::cubbystack::params::sahara_api_package_name,
    service_name   => $::cubbystack::params::sahara_api_service_name,
    tags           => $::cubbystack::sahara::tags,
  }

}
