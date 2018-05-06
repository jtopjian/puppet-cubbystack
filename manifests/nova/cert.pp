# == Class: cubbystack::nova::cert
#
# Configures the nova-cert package and service
#
# === Parameters
#
# [*package_ensure*]
#   The status of the nova-cert package
#   Defaults to present
#
# [*service_enable*]
#   The status of the nova-cert service
#   Defaults to true
#
# [*service_ensure*]
#   The run status of the nova-cert service
#   Defaults to running
#
class cubbystack::nova::cert (
  $package_ensure = present,
  $service_enable = true,
  $service_ensure = 'running',
) {

  contain ::cubbystack::nova

  cubbystack::functions::generic_service { 'nova-cert':
    service_enable => $service_enable,
    service_ensure => $service_ensure,
    package_ensure => $package_ensure,
    package_name   => $::cubbystack::params::nova_cert_package_name,
    service_name   => $::cubbystack::params::nova_cert_service_name,
    tags           => $::cubbystack::nova::tags,
  }

}
