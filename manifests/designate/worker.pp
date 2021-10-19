# == Class: cubbystack::designate::worker
#
# Configures the designate-worker package and service
#
# === Parameters
#
# [*package_ensure*]
#   The status of the designate-worker package
#   Defaults to latest
#
# [*service_enable*]
#   The status of the designate-worker service
#   Defaults to true
#
# [*service_ensure*]
#   The status of the designate-worker service
#   Defaults to running
#
class cubbystack::designate::worker (
  $package_ensure = latest,
  $service_enable = true,
  $service_ensure = 'running',
) {

  include ::cubbystack::designate

  cubbystack::functions::generic_service { 'designate-worker':
    service_enable => $service_enable,
    service_ensure => $service_ensure,
    package_ensure => $package_ensure,
    package_name   => $::cubbystack::params::designate_worker_package_name,
    service_name   => $::cubbystack::params::designate_worker_service_name,
    tags           => $::cubbystack::designate::tags,
  }

}
