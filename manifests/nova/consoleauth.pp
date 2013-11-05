# == Class: cubbystack::nova::consoleauth
#
# Configures the nova-consoleauth package and service
#
# === Parameters
#
# [*package_ensure*]
#   The status of the nova-consoleauth package
#   Defaults to latest
#
# [*service_enable*]
#   The status of the nova-consoleauth service
#   Defaults to true
#
# === Example Usage
#
# Please see the `examples` directory.
#
class cubbystack::nova::consoleauth (
  $package_ensure = latest,
  $service_enable = true
) {

  include ::cubbystack::nova

  cubbystack::functions::generic_service { 'nova-consoleauth':
    service_enable => $service_enable,
    package_ensure => $package_ensure,
    package_name   => $::cubbystack::params::nova_consoleauth_package_name,
    service_name   => $::cubbystack::params::nova_consoleauth_service_name,
    tags           => $::cubbystack::nova::tags,
  }

}
