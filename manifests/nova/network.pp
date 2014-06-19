# == Class: cubbystack::nova::network
#
# Configures the nova-network package and service
#
# === Parameters
#
# [*private_interface*]
#   The NIC for OpenStack to communicate on
#   Required
#
# [*fixed_range*]
#   The fixed range to add to OpenStack
#   Required
#
# [*package_ensure*]
#   The status of the nova-network package
#   Defaults to latest
#
# [*service_enable*]
#   The status of the nova-network service
#   Defaults to true
#
# [*num_networks*]
#   The number of networks to split $fixed_range into
#   Defaults to 1
#
# [*network_size*]
#   The number of hosts per num_network
#   Defaults to 255
#
# [*floating_range*]
#   A range of floating IP addresses
#   Defaults to false: add no floating IPs
#
# [*network_manager*]
#   The nova-network network driver to use
#   Defaults to flatdhcp manager
#
# [*create_networks*]
#   Whether or not to create any networks
#   Defaults to true
#
# [*install_service*]
#   Whether or not to install/enable nova-network
#   Defaults to true
#
# [*additional_config*]
#   Any additional network configuration needed
#   Defaults to undef
#   Currently only used to pass in vlan_start
#
# === Example Usage
#
# Please see the `manifests/examples` directory.
#
class cubbystack::nova::network (
  $private_interface,
  $fixed_range,
  $package_ensure    = latest,
  $service_enable    = true,
  $num_networks      = 1,
  $network_size      = 255,
  $floating_range    = false,
  $network_manager   = 'nova.network.manager.FlatDHCPManager',
  $create_networks   = true,
  $install_service   = true,
  $vlan_start        = undef,
) {

  include ::cubbystack::nova

  Exec {
    path => $::path
  }
  sysctl::value { 'net.ipv4.ip_forward':
    value => '1',
  }

  # nova-dhcpbridge insists on being 0644
  file { '/var/log/nova/nova-dhcpbridge.log':
    mode => '0644',
  }

  if ($install_service) {
    cubbystack::functions::generic_service { 'nova-network':
      service_enable => $service_enable,
      package_ensure => $package_ensure,
      package_name   => $::cubbystack::params::nova_network_package_name,
      service_name   => $::cubbystack::params::nova_network_service_name,
      tags           => $::cubbystack::nova::tags,
    }
  }

  if ($create_networks) {
    nova_network { 'nova-vm-net':
      ensure       => present,
      network      => $fixed_range,
      num_networks => $num_networks,
      network_size => $network_size,
      vlan_start   => $vlan_start,
      require      => Class['::cubbystack::nova'],
    }

    if ($floating_range) {
      nova_floating { 'nova-vm-floating':
        ensure   => present,
        network  => $floating_range,
        provider => 'nova-manage',
        require      => Class['::cubbystack::nova'],
      }
    }
  }
}
