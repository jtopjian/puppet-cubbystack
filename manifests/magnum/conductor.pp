# == Class: cubbystack::magnum::conductor
#
# Configures the magnum-conductor
#
# === Parameters
#
# [*package_ensure*]
#   The status of the magnum-conductor package
#   Defaults to present
#
# [*service_enable*]
#   The status of the magnum-conductor service
#   Defaults to true
#
# [*service_ensure*]
#   The run status of the magnum-conductor service
#   Defaults to running
#
class cubbystack::magnum::conductor (
  $package_ensure = present,
  $service_enable = true,
  $service_ensure = 'running'
) {

  include ::cubbystack::magnum

  cubbystack::functions::generic_service { 'magnum-conductor':
    service_enable => $service_enable,
    service_ensure => $service_ensure,
    package_ensure => $package_ensure,
    package_name   => $::cubbystack::params::magnum_conductor_package_name,
    service_name   => $::cubbystack::params::magnum_conductor_service_name,
    tags           => $::cubbystack::magnum::tags,
  }

}
