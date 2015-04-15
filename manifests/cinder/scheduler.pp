# == Class: cubbystack::cinder::scheduler
#
# Configures the cinder-scheduler package
#
# === Parameters
#
# [*package_ensure*]
#   The status of the cinder-scheduler package
#   Defaults to present
#
# [*service_enable*]
#   The status of the cinder-scheduler service
#   Defaults to true
#
class cubbystack::cinder::scheduler (
  $package_ensure = present,
  $service_enable = true
) {

  cubbystack::functions::generic_service { 'cinder-scheduler':
    service_enable => $service_enable,
    package_ensure => $package_ensure,
    package_name   => $::cubbystack::params::cinder_scheduler_package_name,
    service_name   => $::cubbystack::params::cinder_scheduler_service_name,
    tags           => $::cubbystack::cinder::tags,
  }

}
