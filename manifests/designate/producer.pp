# == Class: cubbystack::designate::producer
#
# Configures the designate-producer package and service
#
# === Parameters
#
# [*package_ensure*]
#   The status of the designate-producer package
#   Defaults to latest
#
# [*service_enable*]
#   The status of the designate-producer service
#   Defaults to true
#
# [*service_ensure*]
#   The status of the designate-producer service
#   Defaults to running
#
class cubbystack::designate::producer (
  $package_ensure = latest,
  $service_enable = true,
  $service_ensure = 'running',
) {

  include ::cubbystack::designate

  cubbystack::functions::generic_service { 'designate-producer':
    service_enable => $service_enable,
    service_ensure => $service_ensure,
    package_ensure => $package_ensure,
    package_name   => $::cubbystack::params::designate_producer_package_name,
    service_name   => $::cubbystack::params::designate_producer_service_name,
    tags           => $::cubbystack::designate::tags,
  }

}
