# == Class: cubbystack::nova::api_metadata
#
# Configures the nova-api_metadata package and service
#
# === Parameters
#
# [*package_ensure*]
#   The status of the nova-api_metadata package
#   Defaults to latest
#
# [*service_enable*]
#   The status of the nova-api_metadata service
#   Defaults to true
#
# === Example Usage
#
# Please see the `examples` directory.
#
class cubbystack::nova::api_metadata (
  $package_ensure = latest,
  $service_enable = true
) {

  include ::cubbystack::nova

  cubbystack::functions::generic_service { 'nova-api-metadata':
    service_enable => $service_enable,
    package_ensure => $package_ensure,
    package_name   => $::cubbystack::params::nova_api_metadata_package_name,
    service_name   => $::cubbystack::params::nova_api_metadata_service_name,
    tags           => $::cubbystack::nova::tags,
  }

}
