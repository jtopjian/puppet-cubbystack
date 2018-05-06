# == Class: cubbystack::keystone
#
# Configures the keystone package and keystone.conf
#
# === Parameters
#
# [*settings*]
#   A hash of key => value settings to go in keystone.conf
#
# [*package_ensure*]
#   The status of the keystone package
#   Defaults to present
#
# [*service_enable*]
#   The status of the keystone service
#   Defaults to false
#
# [*service_ensure*]
#   The run status of the keystone service
#   Defaults to stopped
#
# [*config_file*]
#   The path to keystone.conf
#   Defaults to /etc/keystone/keystone.conf.
#
class cubbystack::keystone (
  $settings,
  $package_ensure = present,
  $service_enable = false,
  $service_ensure = 'stopped',
  $config_file    = '/etc/keystone/keystone.conf',
) {

  contain ::apache
  contain ::cubbystack::params

  ## Meta settings and globals
  $tags = ['cubbystack_keystone', 'cubbystack_openstack']

  # Make sure keystone.conf exists before any configuration happens
  Package['keystone'] -> Cubbystack_config<| tag == 'cubbystack_keystone' |>

  # Also, any changes to keystone.conf should restart the keystone service
  Cubbystack_config<| tag == 'cubbystack_keystone' |> ~> Service['apache2']
  Exec['keystone-manage db_sync'] ~> Service['apache2']

  # Order the db sync correctly
  Package['keystone'] ~> Exec['keystone-manage db_sync']
  Cubbystack_config<| tag == 'cubbystack_keystone' |> -> Exec['keystone-manage db_sync']
  Exec['keystone-manage db_sync'] -> Service['apache2']

  # Other ordering
  Cubbystack::Functions::Create_keystone_endpoint<||> -> Service['apache2']
  Cubbystack::Functions::Create_keystone_endpoint<||> ~> Service['apache2']

  # Global file attributes
  File {
    ensure  => present,
    owner   => 'keystone',
    group   => 'keystone',
    mode    => '0640',
    tag     => $tags,
    require => Package['keystone'],
  }

  cubbystack::functions::generic_service { 'keystone':
    package_ensure => $package_ensure,
    service_enable => $service_enable,
    service_ensure => $service_ensure,
    package_name   => $::cubbystack::params::keystone_package_name,
    service_name   => $::cubbystack::params::keystone_service_name,
    tags           => $tags,
  }

  # Some keystone files
  file {
    ['/etc/keystone', '/var/log/keystone', '/var/lib/keystone']:
      ensure  => directory,
      recurse => true;
    $config_file:
      mode => '0600';
    '/var/log/keystone/keystone.log':;
  }

  # Configure the keystone.conf file
  $settings.each |$setting, $value| {
    cubbystack_config { "${config_file}: ${setting}":
      value => $value,
      tag   => $tags,
    }
  }

  # Catalog configuration
  if $settings['catalog/driver'] == "templated" {
    contain ::cubbystack::keystone::templated_catalog
  }

  ## Keystone database sync
  # Run a db_sync if the package is installed or upgraded
  exec { 'keystone-manage db_sync':
    path        => '/usr/bin',
    refreshonly => true,
    logoutput   => 'on_failure',
  }

}
