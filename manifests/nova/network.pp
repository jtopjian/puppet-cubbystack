# == Class: cubbystack::nova::network
#
# Configures the nova-network package and service
#
# === Parameters
#
# [*package_ensure*]
#   The status of the nova-network package
#   Defaults to latest
#
# [*service_enable*]
#   The status of the nova-network service
#   Defaults to true
#
# [*install_service*]
#   Whether or not to install/enable nova-network
#   Defaults to true
#
class cubbystack::nova::network (
  $package_ensure   = latest,
  $service_enable   = true,
  $install_service  = true,
) {

  include ::cubbystack::nova

  # TODO: Move to firewall config
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

}
