# == Class: cubbystack::magnum::api
#
# Configures the magnum-api
#
# === Parameters
#
# [*package_ensure*]
#   The status of the magnum-api package
#   Defaults to present
#
# [*service_enable*]
#   The status of the magnum-api service
#   Defaults to true
#
# [*service_ensure*]
#   The run status of the magnum-api service
#   Defaults to running
#
class cubbystack::magnum::api (
  $package_ensure = present,
  $service_enable = true,
  $service_ensure = 'running'
) {

  include ::cubbystack::magnum

  cubbystack::functions::generic_service { 'magnum-api':
    service_enable => $service_enable,
    service_ensure => $service_ensure,
    package_ensure => $package_ensure,
    package_name   => $::cubbystack::params::magnum_api_package_name,
    service_name   => $::cubbystack::params::magnum_api_service_name,
    tags           => $::cubbystack::magnum::tags,
  }

}
