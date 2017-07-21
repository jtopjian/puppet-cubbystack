# == Class: cubbystack::heat::engine
#
# Configures the heat-engine package and service
#
# === Parameters
#
# [*package_ensure*]
#   The status of the heat-engine package
#   Defaults to present
#
# [*service_enable*]
#   The status of the heat-engine service
#   Defaults to true
#
# [*service_ensure*]
#   The run status of the heat-engine service
#   Defaults to running
#
class cubbystack::heat::engine (
  $package_ensure = present,
  $service_enable = true
  $service_ensure = 'running'
) {

  include ::cubbystack::heat

  cubbystack::functions::generic_service { 'heat-engine':
    service_enable => $service_enable,
    service_ensure => $service_ensure,
    package_ensure => $package_ensure,
    package_name   => $::cubbystack::params::heat_engine_package_name,
    service_name   => $::cubbystack::params::heat_engine_service_name,
    tags           => $::cubbystack::heat::tags,
  }

}
