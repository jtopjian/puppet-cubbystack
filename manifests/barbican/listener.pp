# == Class: cubbystack::barbican::listener
#
# Configures the barbican-listener
#
# === Parameters
#
# [*package_ensure*]
#   The status of the barbican-listener package
#   Defaults to present
#
# [*service_enable*]
#   The status of the barbican-listener service
#   Defaults to true
#
# [*service_ensure*]
#   The run status of the barbican-listener service
#   Defaults to running
#
class cubbystack::barbican::listener (
  $package_ensure = present,
  $service_enable = true,
  $service_ensure = 'running'
) {

  cubbystack::functions::generic_service { 'barbican-listener':
    service_enable => $service_enable,
    service_ensure => $service_ensure,
    package_ensure => $package_ensure,
    package_name   => $::cubbystack::params::barbican_listener_package_name,
    service_name   => $::cubbystack::params::barbican_listener_service_name,
    tags           => $::cubbystack::barbican::tags,
  }

}
