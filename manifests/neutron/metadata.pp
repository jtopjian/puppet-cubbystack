# == Class: cubbystack::neutron::metadata
#
# Configures the neutron-metadata
#
# === Parameters
#
# [*package_ensure*]
#   The status of the neutron-metadata package
#   Defaults to latest
#
# [*service_enable*]
#   The status of the neutron-metadata service
#   Defaults to true
#
# [*settings*]
#   A hash of key => value settings to go in metadata_agent.ini
#
# [*config_file*]
#   The path to metadata_agent.ini
#   Defaults to /etc/neutron/metadata_agent.ini
#
class cubbystack::neutron::metadata (
  $settings,
  $package_ensure = latest,
  $service_enable = true,
  $config_file    = '/etc/neutron/metadata_agent.ini',
) {

  include ::cubbystack::params

  ## Meta settings and globals
  $tags = ['openstack', 'neutron', 'neutron-metadata']

  # Make sure Neutron Metadata is installed before any configuration begins
  # Make sure Neutron Metadata is configured before the service starts
  Package<| tag == 'neutron' |> -> Cubbystack_config<| tag == 'neutron-metadata' |>
  Package<| tag == 'neutron' |> -> File<| tag == 'neutron-metadata' |>
  Cubbystack_config<| tag == 'neutron-metadata' |> -> Service['neutron-metadata']

  # Restart neutron-metadata after any config changes
  Cubbystack_config<| tag == 'neutron-metadata' |> ~> Service['neutron-metadata']

  File {
    ensure => present,
    owner  => 'neutron',
    group  => 'neutron',
    mode   => '0640',
    tag    => $tags,
    notify => Service['neutron-metadata'],
  }

  ## Neutron Metadata configuration
  file { $config_file: }

  # Configure the Metadata service
  $settings.each |$setting, $value| {
    cubbystack_config { "${config_file}: ${setting}":
      value => $value,
      tag   => $tags,
    }
  }

  cubbystack::functions::generic_service { 'neutron-metadata':
    service_enable => $service_enable,
    package_ensure => $package_ensure,
    package_name   => $::cubbystack::params::neutron_metadata_package_name,
    service_name   => $::cubbystack::params::neutron_metadata_service_name,
    tags           => $tags,
  }

}
