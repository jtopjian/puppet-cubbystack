# == Class: cubbystack::designate::sink
#
# Configures the designate-sink package and service
#
# === Parameters
#
# [*package_ensure*]
#   The status of the designate-sink package
#   Defaults to present
#
# [*service_enable*]
#   The status of the designate-sink service
#   Defaults to true
#
# [*service_ensure*]
#   The run status of the designate-sink service
#   Defaults to running
#
class cubbystack::designate::sink (
  $package_ensure  = present,
  $service_enable  = true,
  $service_ensure  = 'running',
) {

  contain ::cubbystack::designate

  cubbystack::functions::generic_service { 'designate-sink':
    service_enable => $service_enable,
    service_ensure => $service_ensure,
    package_ensure => $package_ensure,
    package_name   => $::cubbystack::params::designate_sink_package_name,
    service_name   => $::cubbystack::params::designate_sink_service_name,
    tags           => $::cubbystack::designate::tags,
  }

}
