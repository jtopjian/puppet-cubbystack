# == Class: cubbystack::nova::placement
#
# Configures the nova-placement package and service
#
# === Parameters
#
# [*package_ensure*]
#   The status of the nova-api package
#   Defaults to present
#
class cubbystack::nova::placement (
  $package_ensure = present,
) {

  contain ::cubbystack::nova

  package { 'nova-placement':
    ensure => $package_ensure,
    name   => $::cubbystack::params::nova_placement_package_name,
    tag    => $::cubbystack::nova::tags,
  }

  $apache_service_name = $::cubbystack::params::apache_service_name
  exec { 'nova-placement-apache':
    path        => ['/bin', '/usr/sbin'],
    command     => "service ${apache_service_name} restart",
    refreshonly => true,
    logoutput   => 'on_failure',
    tag         => 'cubbystack-nova-placement-apache',
  }
}
