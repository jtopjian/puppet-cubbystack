# == Class: cubbystack::nova::compute::libvirt
#
# Configures openstack-compute to use libvirt
#
# === Parameters
#
# [*package_ensure*]
#   The status of the nova-api package
#   Defaults to present
#
# [*libvirt_type*]
#   The libvirt category to use
#   Defaults to kvm
#
class cubbystack::nova::compute::libvirt (
  $package_ensure = present,
  $libvirt_type   = 'kvm'
) {

  include ::cubbystack::params
  include ::cubbystack::nova

  $package_name = "${::cubbystack::params::nova_compute_package_name}-${libvirt_type}"
  Package[$package_name] ~> Service<| tag == 'nova' |>

  cubbystack::functions::generic_service { $package_name:
    package_ensure => $package_ensure,
    package_name   => $package_name,
    tags           => $::cubbystack::nova::tags,
  }

  cubbystack::functions::generic_service { 'libvirt':
    package_name   => $::cubbystack::params::libvirt_package_name,
    service_name   => $::cubbystack::params::libvirt_service_name,
    package_ensure => $package_ensure,
    tags           => ['openstack', 'libvirt'],
  }

}
