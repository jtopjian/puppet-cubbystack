# == Class: cubbystack::nova::placement
#
# Configures the nova-placement package and service
#
# === Parameters
#
# [*package_ensure*]
#   The status of the nova-api package
#   Defaults to present
# [*service_enable*]
#   The status of the nova-api service
#   Defaults to true
#
# [*service_ensure*]
#   The run status of the nova-api service
#   Defaults to running
#
class cubbystack::nova::placement (
  $settings,
  $package_ensure = present,
  $config_file   = '/etc/placement/placement.conf',
  $service_enable = true,
  $service_ensure = 'running',
) {

  contain ::cubbystack::nova

  cubbystack::functions::generic_service { 'nova-placement':
    service_enable => $service_enable,
    service_ensure => $service_ensure,
    package_ensure => $package_ensure,
    package_name   => $::cubbystack::params::nova_placement_package_name,
    service_name   => $::cubbystack::params::nova_placement_service_name,
    tags           => $::cubbystack::nova::tags,
  }

  $apache_service_name = $::cubbystack::params::apache_service_name
  exec { 'nova-placement-apache':
    path        => ['/bin', '/usr/sbin'],
    command     => "service ${apache_service_name} restart",
    refreshonly => true,
    logoutput   => 'on_failure',
    tag         => 'cubbystack_nova_placement_apache',
  }

  file { '/var/log/placement':
    ensure  => directory,
    recurse =>  true,
  }

  file { '/etc/placement':
    ensure  => directory,
    recurse =>  true,
  }

  file { $config_file: }

  ## Configure placement.conf
  $settings.each |$setting, $value| {
    cubbystack_config { "${config_file}: ${setting}":
      value => $value,
      tag   => $tags,
    }
  }
}
