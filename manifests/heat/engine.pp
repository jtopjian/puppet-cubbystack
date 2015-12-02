# == Class: cubbystack::heat::engine
#
# Configures the heat-engine package and service
#
# === Parameters
#
# [*package_ensure*]
#   The status of the heat-engine package
#   Defaults to latest
#
# [*service_enable*]
#   The status of the heat-engine service
#   Defaults to true
#
class cubbystack::heat::engine (
  $package_ensure = latest,
  $service_enable = true
) {

  include ::cubbystack::heat

  cubbystack::functions::generic_service { 'heat-engine':
    service_enable => $service_enable,
    package_ensure => $package_ensure,
    package_name   => $::cubbystack::params::heat_engine_package_name,
    service_name   => $::cubbystack::params::heat_engine_service_name,
    tags           => $::cubbystack::heat::tags,
  }

}
