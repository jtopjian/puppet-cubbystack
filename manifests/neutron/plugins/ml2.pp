# == Class: cubbystack::neutron::plugins::ml2
#
# Configures the neutron-plugin-ml2
#
# === Parameters
#
# [*package_ensure*]
#   The status of the neutron-plugin-ml2 package
#   Defaults to latest
#
# [*settings*]
#   A hash of key => value settings to go in ml2_conf.ini
#
# [*config_file*]
#   The path to ml2_conf.ini
#   Defaults to /etc/neutron/plugins/ml2/ml2_conf.ini
#
class cubbystack::neutron::plugins::ml2 (
  $settings,
  $package_ensure = latest,
  $config_file    = '/etc/neutron/plugins/ml2/ml2_conf.ini',
) {

  include ::cubbystack::params

  ## Meta settings and globals
  $tags = ['openstack', 'neutron', 'neutron-plugin-ml2']

  # Make sure Neutron Open vSwitch is installed before any configuration begins
  # Make sure Neutron Open vSwitch is configured before the service starts
  Package['neutron-plugin-ml2'] -> Cubbystack_config<| tag == 'neutron' |>

  # Restart neutron-plugin-ml2 after any config changes
  Cubbystack_config<| tag == 'neutron-plugin-ml2' |> ~> Service<| tag == 'neutron' |>

  File {
    ensure  => present,
    owner   => 'neutron',
    group   => 'neutron',
    mode    => '0640',
    tag     => $tags,
    require => Package['neutron-plugin-ml2'],
  }

  ## Neutron Open vSwitch configuration
  file { $config_file: }

  # Configure the Open vSwitch service
  $settings.each |$setting, $value| {
    cubbystack_config { "${config_file}: ${setting}":
      value => $value,
      tag   => $tags,
    }
  }

  package { 'neutron-plugin-ml2':
    ensure => $package_ensure,
    name   => $::cubbystack::params::neutron_plugin_ml2_package_name,
    tag    => $tags,
  }

}
