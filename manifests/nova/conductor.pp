# == Class: cubbystack::nova::conductor
#
# Configures the nova-conductor package and service
#
# === Parameters
#
# [*package_ensure*]
#   The status of the nova-conductor package
#   Defaults to latest
#
# [*service_enable*]
#   The status of the nova-conductor service
#   Defaults to true
#
class cubbystack::nova::conductor (
  $package_ensure = latest,
  $service_enable = true
) {

  include ::cubbystack::nova

  cubbystack::functions::generic_service { 'nova-conductor':
    service_enable => $service_enable,
    package_ensure => $package_ensure,
    package_name   => $::cubbystack::params::nova_conductor_package_name,
    service_name   => $::cubbystack::params::nova_conductor_service_name,
    tags           => $::cubbystack::nova::tags,
  }

}
