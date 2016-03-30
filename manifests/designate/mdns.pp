# == Class: cubbystack::designate::mdns
#
# Configures the designate-mdns package and service
#
# === Parameters
#
# [*package_ensure*]
#   The status of the designate-mdns package
#   Defaults to latest
#
# [*service_enable*]
#   The status of the designate-mdns service
#   Defaults to true
#
# [*service_ensure*]
#   The run status of the designate-mdns service
#   Defaults to running
#
class cubbystack::designate::mdns (
  $package_ensure  = latest,
  $service_enable  = true,
  $service_ensure  = 'running',
) {

  include ::cubbystack::designate

  cubbystack::functions::generic_service { 'designate-mdns':
    service_enable => $service_enable,
    service_ensure => $service_ensure,
    package_ensure => $package_ensure,
    package_name   => $::cubbystack::params::designate_mdns_package_name,
    service_name   => $::cubbystack::params::designate_mdns_service_name,
    tags           => $::cubbystack::designate::tags,
  }

}
