# == Class: cubbystack::neutron::plugins::ml2_sriov
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
#   A hash of key => value settings to go in ml2_conf_sriov.ini
#
# [*config_file*]
#   The path to ml2_conf_sriov.ini
#   Defaults to /etc/neutron/plugins/ml2/ml2_conf_sriov.ini
#
class cubbystack::neutron::plugins::ml2_sriov (
  $settings,
  $package_ensure = present,
  $config_file    = '/etc/neutron/plugins/ml2/sriov_agent.ini',
) {

  contain ::cubbystack::params

  ## Meta settings and globals
  $tags = ['cubbystack_openstack', 'cubbystack_neutron', 'neutron-plugin-sriov']

  # Make sure Neutron Open vSwitch is installed before any configuration begins
  # Make sure Neutron Open vSwitch is configured before the service starts
  Package['neutron-plugin-sriov'] -> Cubbystack_config<| tag == 'cubbystack_neutron' |>

  # Restart neutron-plugin-ml2 after any config changes
  Cubbystack_config<| tag == 'neutron-plugin-sriov' |> ~> Service<| tag == 'cubbystack_neutron' |>

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
