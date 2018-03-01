# == Class: cubbystack::murano::api
#
# Configures the murano-api package and service
#
# === Parameters
#
# [*package_ensure*]
#   The status of the murano-api package
#   Defaults to latest
#
# [*service_enable*]
#   The status of the murano-registry service
#   Defaults to true
#
class cubbystack::murano::api (
  $package_ensure = latest,
  $service_enable = true,
) {

  include ::cubbystack::murano

  cubbystack::functions::generic_service { 'murano-api':
    service_enable => $service_enable,
    package_ensure => $package_ensure,
    package_name   => $::cubbystack::params::murano_api_package_name,
    service_name   => $::cubbystack::params::murano_api_service_name,
    tags           => $::cubbystack::murano::tags,
  }

}
