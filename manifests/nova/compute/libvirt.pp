# == Class: cubbystack::nova::compute::libvirt
#
# Configures openstack-compute to use libvirt
#
# === Parameters
#
# [*package_ensure*]
#   The status of the nova-api package
#   Defaults to latest
#
# [*libvirt_type*]
#   The libvirt category to use
#   Defaults to kvm
#
# === Example Usage
#
# Please see the `manifests/examples` directory.
#
class cubbystack::nova::compute::libvirt (
  $package_ensure = latest,
  $libvirt_type   = 'kvm'
) {

  include ::cubbystack::params

  package { "${::cubbystack::params::nova_compute_package_name}-${libvirt_type}":
    ensure => $package_ensure,
  }

}
