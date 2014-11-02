# == Class: cubbystack::neutron::plugins::linuxbridge
#
# Configures the neutron-plugin-linuxbridge
#
# === Parameters
#
# [*package_ensure*]
#   The status of the neutron-plugin-linuxbridge package
#   Defaults to latest
#
# [*service_enable*]
#   The status of the neutron-plugin-linuxbridge service
#   Defaults to true
#
# [*settings*]
#   A hash of key => value settings to go in linuxbridge_conf.ini
#
# [*config_file*]
#   The path to linuxbridge_conf.ini
#   Defaults to /etc/neutron/plugins/linuxbridge/linuxbridge_conf.ini
#
class cubbystack::neutron::plugins::linuxbridge (
  $settings,
  $package_ensure = latest,
  $service_enable = true,
  $config_file    = '/etc/neutron/plugins/linuxbridge/linuxbridge_conf.ini',
) {

  include ::cubbystack::params

  ## Meta settings and globals
  $tags = ['openstack', 'neutron', 'neutron-plugin-linuxbridge']

  # Make sure Neutron Open vSwitch is installed before any configuration begins
  # Make sure Neutron Open vSwitch is configured before the service starts
  Package['neutron-plugin-linuxbridge'] -> Cubbystack_config<| tag == 'neutron-plugin-linuxbridge' |>
  Cubbystack_config<| tag == 'neutron-plugin-linuxbridge' |> -> Service['neutron-plugin-linuxbridge']

  # Restart neutron-plugin-linuxbridge after any config changes
  Cubbystack_config<| tag == 'neutron-plugin-linuxbridge' |> ~> Service['neutron-plugin-linuxbridge']

  File {
    ensure  => present,
    owner   => 'neutron',
    group   => 'neutron',
    mode    => '0640',
    tag     => $tags,
    notify  => Service['neutron-plugin-linuxbridge'],
    require => Package['neutron-plugin-linuxbridge'],
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

  cubbystack::functions::generic_service { 'neutron-plugin-linuxbridge':
    service_enable => $service_enable,
    package_ensure => $package_ensure,
    package_name   => $::cubbystack::params::neutron_plugin_linuxbridge_package_name,
    service_name   => $::cubbystack::params::neutron_plugin_linuxbridge_service_name,
    tags           => $tags,
  }

}
