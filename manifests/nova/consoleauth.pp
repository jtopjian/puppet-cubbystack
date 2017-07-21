# == Class: cubbystack::nova::consoleauth
#
# Configures the nova-consoleauth package and service
#
# === Parameters
#
# [*package_ensure*]
#   The status of the nova-consoleauth package
#   Defaults to present
#
# [*service_enable*]
#   The status of the nova-consoleauth service
#   Defaults to true
#
# [*service_ensure*]
#   The run status of the nova-consoleauth service
#   Defaults to running
#
class cubbystack::nova::consoleauth (
  $package_ensure = present,
  $service_enable = true,
  $service_ensure = 'running',
) {

  include ::cubbystack::nova

  cubbystack::functions::generic_service { 'nova-consoleauth':
    service_enable => $service_enable,
    service_ensure => $service_ensure,
    package_ensure => $package_ensure,
    package_name   => $::cubbystack::params::nova_consoleauth_package_name,
    service_name   => $::cubbystack::params::nova_consoleauth_service_name,
    tags           => $::cubbystack::nova::tags,
  }

}
