# == Class: cubbystack::designate::central
#
# Configures the designate-central service
#
# === Parameters
#
# [*service_enable*]
#   The status of the designate-central service
#   Defaults to true
#
# [*service_ensure*]
#   The run status of the designate-central service
#   Defaults to running
#
class cubbystack::designate::central (
  $package_ensure = present,
  $service_enable = true,
  $service_ensure = 'running',
) {

  include ::cubbystack::designate

  cubbystack::functions::generic_service { 'designate-central':
    service_enable    => $service_enable,
    service_ensure    => $service_ensure,
    service_name      => $::cubbystack::params::designate_central_service_name,
    package_ensure    => $package_ensure,
    package_name      => $::cubbystack::params::designate_central_package_name,
    tags              => $::cubbystack::designate::tags,
  }
}
