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
# [*install_service*]
#   Whether or not to install/enable designate-mdns
#   Defaults to true
#
# === Example Usage
#
# Please see the `examples` directory.
#
class cubbystack::designate::mdns (
  $package_ensure   = latest,
  $service_enable   = true,
  $install_service  = true,
) {

  include ::cubbystack::designate

  if ($install_service) {
    cubbystack::functions::generic_service { 'designate-mdns':
      service_enable => $service_enable,
      package_ensure => $package_ensure,
      package_name   => $::cubbystack::params::designate_mdns_package_name,
      service_name   => $::cubbystack::params::designate_mdns_service_name,
      tags           => $::cubbystack::designate::tags,
    }
  }

}
