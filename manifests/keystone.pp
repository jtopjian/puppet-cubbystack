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
#   Defaults to latest
#
# [*service_enable*]
#   The status of the keystone service
#   Defaults to true
#
# [*config_file*]
#   The path to keystone.conf
#   Defaults to /etc/keystone/keystone.conf.
#
class cubbystack::keystone (
  $settings,
  $package_ensure = latest,
  $service_enable = true,
  $config_file    = '/etc/keystone/keystone.conf',
) {

  include ::cubbystack::params

  ## Meta settings and globals
  $tags = ['keystone', 'openstack']

  # Make sure keystone.conf exists before any configuration happens
  Package['keystone'] -> Cubbystack_config<| tag == 'keystone' |>

  # Also, any changes to keystone.conf should restart the keystone service
  Cubbystack_config<| tag == 'keystone' |> ~> Service['keystone']
  Exec['keystone-manage db_sync']          ~> Service['keystone']

  # Order the db sync correctly
  Package['keystone'] ~> Exec['keystone-manage db_sync']
  Cubbystack_config<| tag == 'keystone' |> -> Exec['keystone-manage db_sync']
  Exec['keystone-manage db_sync'] -> Service['keystone']

  # Other ordering
  Cubbystack::Functions::Create_keystone_endpoint<||> -> Service['keystone']
  Cubbystack::Functions::Create_keystone_endpoint<||> ~> Service['keystone']

  # Global file attributes
  File {
    ensure  => present,
    owner   => 'keystone',
    group   => 'keystone',
    mode    => '0640',
    tag     => $tags,
    require => Package['keystone'],
  }

  ## Keystone configuration

  # Install keystone and manage its service
  cubbystack::functions::generic_service { 'keystone':
    package_ensure => $package_ensure,
    service_enable => $service_enable,
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
  if ($settings['catalog/driver'] == 'keystone.catalog.backends.templated.Catalog') {
    class { '::cubbystack::keystone::templated_catalog': }
  }

  ## Keystone database sync
  # Run a db_sync if the package is installed or upgraded
  if $service_enable {
    exec { 'keystone-manage db_sync':
      path        => '/usr/bin',
      refreshonly => true,
      logoutput   => 'on_failure',
    }
  }

}
