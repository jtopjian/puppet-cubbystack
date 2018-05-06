# == Class: cubbystack::murano::engine
#
# Configures the murano-engine package and service
#
# === Parameters
#
# [*package_ensure*]
#   The status of the murano-engine package
#   Defaults to present
#
# [*service_enable*]
#   The status of the murano-registry service
#   Defaults to true
#
class cubbystack::murano::engine (
  $package_ensure = present,
  $service_enable = true,
  $service_ensure = 'running',
) {

  include ::cubbystack::murano

  cubbystack::functions::generic_service { 'murano-engine':
    service_enable => $service_enable,
    service_ensure => $service_ensure,
    package_ensure => $package_ensure,
    package_name   => $::cubbystack::params::murano_engine_package_name,
    service_name   => $::cubbystack::params::murano_engine_service_name,
    tags           => $::cubbystack::murano::tags,
  }

}
