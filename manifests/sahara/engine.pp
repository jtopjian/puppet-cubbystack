# == Class: cubbystack::sahara::engine
#
# Configures the sahara-engine package and service
#
# === Parameters
#
# [*package_ensure*]
#   The status of the sahara-engine package
#   Defaults to present
#
# [*service_enable*]
#   The status of the sahara-registry service
#   Defaults to true
#
class cubbystack::sahara::engine (
  $package_ensure = present,
  $service_enable = true,
) {

  contain ::cubbystack::sahara

  cubbystack::functions::generic_service { 'sahara-engine':
    service_enable => $service_enable,
    package_ensure => $package_ensure,
    package_name   => $::cubbystack::params::sahara_engine_package_name,
    service_name   => $::cubbystack::params::sahara_engine_service_name,
    tags           => $::cubbystack::sahara::tags,
  }

}
