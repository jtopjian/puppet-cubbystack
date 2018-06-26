# == Class: cubbystack::neutron::metadata
#
# Configures the neutron-metadata
#
# === Parameters
#
# [*package_ensure*]
#   The status of the neutron-metadata package
#   Defaults to present
#
# [*service_enable*]
#   The status of the neutron-metadata service
#   Defaults to true
#
# [*service_ensure*]
#   The run status of the neutron-metadata service
#   Defaults to running
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
  $package_ensure = present,
  $service_enable = true,
  $service_ensure = 'running',
  $config_file    = '/etc/neutron/metadata_agent.ini',
) {

  contain ::cubbystack::params

  ## Meta settings and globals
  $tags = ['cubbystack_openstack', 'cubbystack_neutron', 'neutron-metadata']

  # Make sure Neutron Metadata is installed before any configuration begins
  # Make sure Neutron Metadata is configured before the service starts
  Package<| tag == 'cubbystack_neutron' |> -> Cubbystack_config<| tag == 'neutron-metadata' |>
  Package<| tag == 'cubbystack_neutron' |> -> File<| tag == 'neutron-metadata' |>
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
    service_ensure => $service_ensure,
    package_ensure => $package_ensure,
    package_name   => $::cubbystack::params::neutron_metadata_package_name,
    service_name   => $::cubbystack::params::neutron_metadata_service_name,
    tags           => $tags,
  }

}
