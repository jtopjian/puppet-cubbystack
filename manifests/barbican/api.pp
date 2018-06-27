# == Class: cubbystack::barbican::api
#
# Configures the barbican-api
#
# === Parameters
#
# [*package_ensure*]
#   The status of the barbican-api package
#   Defaults to present
#
# [*service_enable*]
#   The status of the barbican-api service
#   Defaults to true
#
# [*service_ensure*]
#   The run status of the barbican-api service
#   Defaults to running
#
class cubbystack::barbican::api (
  $package_ensure = present,
  $service_enable = true,
  $service_ensure = 'running'
) {

  cubbystack::functions::generic_service { 'barbican-api':
    service_enable => $service_enable,
    service_ensure => $service_ensure,
    package_ensure => $package_ensure,
    package_name   => $::cubbystack::params::barbican_api_package_name,
    service_name   => $::cubbystack::params::barbican_api_service_name,
    tags           => $::cubbystack::barbican::tags,
  }

}
