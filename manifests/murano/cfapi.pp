# == Class: cubbystack::murano::cfapi
#
# Configures the murano-cfapi package and service
#
# === Parameters
#
# [*package_ensure*]
#   The status of the murano-cfapi package
#   Defaults to present
#
# [*service_enable*]
#   The status of the murano-registry service
#   Defaults to true
#
class cubbystack::murano::cfapi (
  $package_ensure = present,
  $service_enable = true,
) {

  include ::cubbystack::murano

  cubbystack::functions::generic_service { 'murano-cfapi':
    service_enable => $service_enable,
    package_ensure => $package_ensure,
    package_name   => $::cubbystack::params::murano_cfapi_package_name,
    service_name   => $::cubbystack::params::murano_cfapi_service_name,
    tags           => $::cubbystack::murano::tags,
  }

}
