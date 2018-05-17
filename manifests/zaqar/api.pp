# == Class: cubbystack::zaqar::api
#
# Configures the zaqar-api
#
# === Parameters
#
# [*package_ensure*]
#   The status of the zaqar-api package
#   Defaults to present
#
# [*service_enable*]
#   The status of the zaqar-api service
#   Defaults to true
#
# [*service_ensure*]
#   The run status of the zaqar-api service
#   Defaults to running
#
class cubbystack::zaqar::api (
  $package_ensure = present,
  $service_enable = true,
  $service_ensure = 'running'
) {

  cubbystack::functions::generic_service { 'zaqar-api':
    service_enable => $service_enable,
    service_ensure => $service_ensure,
    package_ensure => $package_ensure,
    package_name   => $::cubbystack::params::zaqar_api_package_name,
    service_name   => $::cubbystack::params::zaqar_api_service_name,
    tags           => $::cubbystack::zaqar::tags,
  }

}
