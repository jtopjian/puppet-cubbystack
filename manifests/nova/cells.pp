# == Class: cubbystack::nova::cells
#
# Configures the nova-cells package and service
#
# === Parameters
#
# [*package_ensure*]
#   The status of the nova-cells package
#   Defaults to latest
#
# [*service_enable*]
#   The status of the nova-cells service
#   Defaults to true
#
# === Example Usage
#
# Please see the `examples` directory.
#
class cubbystack::nova::cells (
  $package_ensure = latest,
  $service_enable = true
) {

  include ::cubbystack::nova

  cubbystack::functions::generic_service { 'nova-cells':
    service_enable => $service_enable,
    package_ensure => $package_ensure,
    package_name   => $::cubbystack::params::nova_cells_package_name,
    service_name   => $::cubbystack::params::nova_cells_service_name,
    tags           => $::cubbystack::nova::tags,
  }

}
