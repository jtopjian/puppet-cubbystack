# == Class: cubbystack::barbican::worker
#
# Configures the barbican-worker
#
# === Parameters
#
# [*package_ensure*]
#   The status of the barbican-worker package
#   Defaults to present
#
# [*service_enable*]
#   The status of the barbican-worker service
#   Defaults to true
#
# [*service_ensure*]
#   The run status of the barbican-worker service
#   Defaults to running
#
class cubbystack::barbican::worker (
  $package_ensure = present,
  $service_enable = true,
  $service_ensure = 'running'
) {

  cubbystack::functions::generic_service { 'barbican-worker':
    service_enable => $service_enable,
    service_ensure => $service_ensure,
    package_ensure => $package_ensure,
    package_name   => $::cubbystack::params::barbican_worker_package_name,
    service_name   => $::cubbystack::params::barbican_worker_service_name,
    tags           => $::cubbystack::barbican::tags,
  }

}
