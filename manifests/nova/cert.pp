# == Class: cubbystack::nova::cert
#
# Configures the nova-cert package and service
#
# === Parameters
#
# [*package_ensure*]
#   The status of the nova-cert package
#   Defaults to latest
#
# [*service_enable*]
#   The status of the nova-cert service
#   Defaults to true
#
class cubbystack::nova::cert (
  $package_ensure = latest,
  $service_enable = true
) {

  include ::cubbystack::nova

  cubbystack::functions::generic_service { 'nova-cert':
    service_enable => $service_enable,
    package_ensure => $package_ensure,
    package_name   => $::cubbystack::params::nova_cert_package_name,
    service_name   => $::cubbystack::params::nova_cert_service_name,
    tags           => $::cubbystack::nova::tags,
  }

}
