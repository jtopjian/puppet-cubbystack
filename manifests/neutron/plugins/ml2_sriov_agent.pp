# == Class: cubbystack::neutron::plugins::ml2_sriov_agent
#
# Configures the neutron-sriov-agent
#
# === Parameters
#
# [*package_ensure*]
#   The status of the neutron-sriov-agent package
#   Defaults to present
#
# [*settings*]
#   A hash of key => value settings to go in sriov_agent.ini
#
# [*config_file*]
#   The path to ml2_conf_sriov.ini
#   Defaults to /etc/neutron/plugins/ml2/sriov_agent.ini
#
class cubbystack::neutron::plugins::ml2_sriov_agent (
  $settings,
  $package_ensure = present,
  $config_file    = '/etc/neutron/plugins/ml2/sriov_agent.ini',
) {

  contain ::cubbystack::params

  ## Meta settings and globals
  $tags = ['openstack', 'neutron', 'neutron-plugin-sriov']

  # Make sure Neutron Open vSwitch is installed before any configuration begins
  # Make sure Neutron Open vSwitch is configured before the service starts
  Package['neutron-plugin-sriov'] -> Cubbystack_config<| tag == 'neutron' |>

  # Restart neutron-plugin-ml2 after any config changes
  Cubbystack_config<| tag == 'neutron-plugin-sriov' |> ~> Service<| tag == 'neutron' |>

  File {
    ensure  => present,
    owner   => 'neutron',
    group   => 'neutron',
    mode    => '0640',
    tag     => $tags,
    require => Package['neutron-plugin-sriov'],
  }

  ## Neutron sriov configuration
  file { $config_file: }

  # Configure the Open vSwitch service
  $settings.each |$setting, $value| {
    cubbystack_config { "${config_file}: ${setting}":
      value => $value,
      tag   => $tags,
    }
  }

  cubbystack::functions::generic_service { 'neutron-plugin-sriov':
    service_enable => $service_enable,
    service_ensure => $service_ensure,
    package_ensure => $package_ensure,
    package_name   => $::cubbystack::params::neutron_plugin_sriov_package_name,
    service_name   => $::cubbystack::params::neutron_plugin_sriov_service_name,
    tags           => $tags,
  }

}
