# == Class: cubbystack::nova::api
#
# Configures the nova-api package and service
#
# === Parameters
#
# [*package_ensure*]
#   The status of the nova-api package
#   Defaults to latest
#
# [*service_enable*]
#   The status of the nova-api service
#   Defaults to true
#
class cubbystack::nova::api (
  $package_ensure = latest,
  $service_enable = true
) {

  include ::cubbystack::nova

  cubbystack::functions::generic_service { 'nova-api':
    service_enable => $service_enable,
    package_ensure => $package_ensure,
    package_name   => $::cubbystack::params::nova_api_package_name,
    service_name   => $::cubbystack::params::nova_api_service_name,
    tags           => $::cubbystack::nova::tags,
  }

}
