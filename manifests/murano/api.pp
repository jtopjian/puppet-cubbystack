# == Class: cubbystack::murano::api
#
# Configures the murano-api package and service
#
# === Parameters
#
# [*package_ensure*]
#   The status of the murano-api package
#   Defaults to present
#
# [*service_enable*]
#   The status of the murano-registry service
#   Defaults to true
#
class cubbystack::murano::api (
  $package_ensure = present,
  $service_enable = true,
  $service_ensure = 'running',
) {

  include ::cubbystack::murano

  cubbystack::functions::generic_service { 'murano-api':
    service_enable => $service_enable,
    service_ensure => $service_ensure,
    package_ensure => $package_ensure,
    package_name   => $::cubbystack::params::murano_api_package_name,
    service_name   => $::cubbystack::params::murano_api_service_name,
    tags           => $::cubbystack::murano::tags,
  }

}
