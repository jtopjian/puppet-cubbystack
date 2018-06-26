# == Class: cubbystack::nova::network
#
# Configures the nova-network package and service
#
# === Parameters
#
# [*package_ensure*]
#   The status of the nova-network package
#   Defaults to present
#
# [*service_enable*]
#   The status of the nova-network service
#   Defaults to true
#
# [*service_ensure*]
#   The run status of the nova-network service
#   Defaults to running
#
# [*install_service*]
#   Whether or not to install/enable nova-network
#   Defaults to true
#
class cubbystack::nova::network (
  $package_ensure   = present,
  $service_enable   = true,
  $service_ensure   = 'running',
  $install_service  = true,
) {

  contain ::cubbystack::nova

  # TODO: Move to firewall config
  sysctl::value { 'net.ipv4.ip_forward':
    value => '1',
  }

  # nova-dhcpbridge insists on being 0644
  file { '/var/log/nova/nova-dhcpbridge.log':
    mode => '0644',
  }

  if $install_service {
    cubbystack::functions::generic_service { 'nova-network':
      service_enable => $service_enable,
      service_ensure => $service_ensure,
      package_ensure => $package_ensure,
      package_name   => $::cubbystack::params::nova_network_package_name,
      service_name   => $::cubbystack::params::nova_network_service_name,
      tags           => $::cubbystack::nova::tags,
    }
  }

}
