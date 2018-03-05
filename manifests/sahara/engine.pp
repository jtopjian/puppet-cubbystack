# == Class: cubbystack::sahara::engine
#
# Configures the sahara-engine package and service
#
# === Parameters
#
# [*package_ensure*]
#   The status of the sahara-engine package
#   Defaults to latest
#
# [*service_enable*]
#   The status of the sahara-registry service
#   Defaults to true
#
class cubbystack::sahara::engine (
  $package_ensure = latest,
  $service_enable = true,
) {

  include ::cubbystack::sahara

  cubbystack::functions::generic_service { 'sahara-engine':
    service_enable => $service_enable,
    package_ensure => $package_ensure,
    package_name   => $::cubbystack::params::sahara_engine_package_name,
    service_name   => $::cubbystack::params::sahara_engine_service_name,
    tags           => $::cubbystack::sahara::tags,
  }

}
