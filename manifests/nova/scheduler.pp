# == Class: cubbystack::nova::scheduler
#
# Configures the nova-scheduler package and service
#
# === Parameters
#
# [*package_ensure*]
#   The status of the nova-scheduler package
#   Defaults to latest
#
# [*service_enable*]
#   The status of the nova-scheduler service
#   Defaults to true
#
# [*service_ensure*]
#   The run status of the nova-scheduler service
#   Defaults to running
#
class cubbystack::nova::scheduler (
  $package_ensure = latest,
  $service_enable = true,
  $service_ensure = 'running'
) {

  contain ::cubbystack::nova

  cubbystack::functions::generic_service { 'nova-scheduler':
    service_enable => $service_enable,
    service_ensure => $service_ensure,
    package_ensure => $package_ensure,
    package_name   => $::cubbystack::params::nova_scheduler_package_name,
    service_name   => $::cubbystack::params::nova_scheduler_service_name,
    tags           => $::cubbystack::nova::tags,
  }

}
