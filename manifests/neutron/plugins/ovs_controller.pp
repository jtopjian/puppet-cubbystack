# == Class: cubbystack::neutron::plugins::ovs_controller
#
# Configures the neutron-openvswitch-agent
#
# === Parameters
#
# [*package_ensure*]
#   The status of the neutron-openvswitch-agent package
#   Defaults to latest
#
# [*settings*]
 #   A hash of key => value settings to go in openvswitch_agent.ini
#
# [*config_file*]
#   The path to openvswitch_agent.ini
#   Defaults to /etc/neutron/plugins/ml2/openvswitch_agent.ini
#
# NEIL #
#
class cubbystack::neutron::plugins::ovs_controller (
  $settings,
  $package_ensure = latest,
  $config_file    = '/etc/neutron/plugins/ml2/openvswitch_agent.ini',
) {

  include ::cubbystack::params

  ## Meta settings and globals
  $tags = ['openstack', 'neutron', 'neutron-openvswitch-agent']

 # Make sure Neutron Open vSwich is installed and configured before any configuration begins
 Package['neutron-openvswitch-agent'] -> Cubbystack_config<| tag == 'neutron' |>

 # Restart neutron-openvswitch-agent after any configuration changes
 Cubbystack_config<| tag =='neutron-openvswitch-agent' |> ~> Service<| tag == 'neutron' |>

 File {
   ensure  => present,
   owner   => 'neutron',
   group   => 'neutron',
   mode    => '0640',
   tag     => $tags,
   require => Package['neutron-openvswitch-agent'],
 }

 # Neutron Open vSwitch configration
 file { $config_file: }

 $settings.each |$setting, $value| {
   cubbystack_config { "${config_file}: ${setting}":
     value => $value,
     tag   => $tags,
   }
 }

  cubbystack::functions::generic_service { 'neutron-openvswitch-agent':
    service_enable => $service_enable,
    service_ensure => $service_ensure,
    package_ensure => $package_ensure,
    package_name   => $::cubbystack::params::neutron_ovs_agent_package_name,
    service_name   => $::cubbystack::params::neutron_ovs_agent_service_name,
    tags           => $tags,
  }

}
