# == Class: cubbystack::nova::objectstore
#
# Configures the nova-objectstore package and service
#
# === Parameters
#
# [*package_ensure*]
#   The status of the nova-objectstore package
#   Defaults to present
#
# [*service_enable*]
#   The status of the nova-objectstore service
#   Defaults to true
#
# [*service_ensure*]
#   The run status of the nova-objectstore service
#   Defaults to running
#
class cubbystack::nova::objectstore (
  $package_ensure = present,
  $service_enable = true
  $service_ensure = 'running'
) {

  include ::cubbystack::nova

  cubbystack::functions::generic_service { 'nova-objectstore':
    service_enable => $service_enable,
    service_ensure => $service_ensure,
    package_ensure => $package_ensure,
    package_name   => $::cubbystack::params::nova_objectstore_package_name,
    service_name   => $::cubbystack::params::nova_objectstore_service_name,
    tags           => $::cubbystack::nova::tags,
  }

}
