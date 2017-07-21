# == Class: cubbystack::neutron::lbaas
#
# Configures the neutron-lbaas
#
# === Parameters
#
# [*package_ensure*]
#   The status of the neutron-lbaas package
#   Defaults to latest
#
# [*service_enable*]
#   The status of the neutron-lbaas service
#   Defaults to true
#
# [*service_ensure*]
#   The run status of the neutron-lbaas service
#   Defaults to running
#
# [*settings*]
#   A hash of key => value settings to go in lbaas_agent.ini
#
# [*config_file*]
#   The path to lbaas_agent.ini
#   Defaults to /etc/neutron/lbaas_agent.ini
#
class cubbystack::neutron::lbaas (
  $settings,
  $neutron_settings,
  $services_settings,
  $package_ensure       = latest,
  $service_enable       = true,
  $service_ensure       = 'running',
  $config_file          = '/etc/neutron/lbaas_agent.ini',
  $neutron_config_file  = '/etc/neutron/neutron_lbaas.conf',
  $services_config_file = '/etc/neutron/services_lbaas.conf'
) {

  include ::cubbystack::params

  ## Meta settings and globals
  $tags = ['openstack', 'neutron', 'neutron-lbaas']

  # Make sure Neutron Metadata is installed before any configuration begins
  # Make sure Neutron Metadata is configured before the service starts
  Package<| tag == 'neutron' |> -> Cubbystack_config<| tag == 'neutron-lbaas' |>
  Package<| tag == 'neutron' |> -> File<| tag == 'neutron-lbaas' |>
  Cubbystack_config<| tag == 'neutron-lbaas' |> -> Service['neutron-lbaas']

  # Restart neutron-lbaas after any config changes
  Cubbystack_config<| tag == 'neutron-lbaas' |> ~> Service['neutron-lbaas']

  # Order the db sync correctly
  Package<| tag == 'neutron-lbaas' |>                     ~> Exec['neutron-db-manage --service lbaas upgrade heads']
  Cubbystack_config<| tag == 'neutron-lbaas' |>           -> Exec['neutron-db-manage --service lbaas upgrade heads']
  Exec['neutron-db-manage --service lbaas upgrade heads'] ~> Service<| tag == 'neutron' |>

  File {
    ensure => present,
    owner  => 'neutron',
    group  => 'neutron',
    mode   => '0640',
    tag    => $tags,
    notify => Service['neutron-lbaas'],
  }

  ## Neutron Metadata configuration
  file { $config_file: }

  # Configure the LBaaS agent
  $settings.each |$setting, $value| {
    cubbystack_config { "${config_file}: ${setting}":
      value => $value,
      tag   => $tags,
    }
  }

  # Configure the LBaaS Neutron settings
  $neutron_settings.each |$setting, $value| {
    cubbystack_config { "${neutron_config_file}: ${setting}":
      value => $value,
      tag   => $tags,
    }
  }

  # Configure the LBaaS Services settings
  $services_settings.each |$setting, $value| {
    cubbystack_config { "${services_config_file}: ${setting}":
      value => $value,
      tag   => $tags,
    }
  }

  # Migrate the database
  exec { 'neutron-db-manage --service lbaas upgrade heads':
    path        => '/usr/bin',
    refreshonly => true,
    logoutput   => 'on_failure',
  }

  cubbystack::functions::generic_service { 'neutron-lbaas':
    service_enable => $service_enable,
    service_ensure => $service_ensure,
    package_ensure => $package_ensure,
    package_name   => $::cubbystack::params::neutron_lbaas_package_name,
    service_name   => $::cubbystack::params::neutron_lbaas_service_name,
    tags           => $tags,
  }

}