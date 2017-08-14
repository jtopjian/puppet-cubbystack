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
# [*service_ensure*]
#   The run status of the neutron-plugin-linuxbridge service
#   Defaults to running
#
class cubbystack::neutron::plugins::linuxbridge (
  $package_ensure = latest,
  $service_enable = true,
  $service_ensure = 'running',
  $config_file    = undef,
  $settings       = undef,
) {

  include ::cubbystack::params

  ## Meta settings and globals
  $tags = ['openstack', 'neutron', 'neutron-plugin-linuxbridge']

  # Make sure Neutron Open vSwitch is installed before any configuration begins
  # Make sure Neutron Open vSwitch is configured before the service starts
  Package['neutron-plugin-linuxbridge'] -> Cubbystack_config<| tag == 'neutron' |>

  File {
    ensure  => present,
    owner   => 'neutron',
    group   => 'neutron',
    mode    => '0640',
    tag     => $tags,
    require => Package['neutron-plugin-ml2'],
  }

  ## Neutron linuxbridge configuration
  if $config_file != undef {
    file { $config_file: }

    $settings.each |$setting, $value| {
      cubbystack_config { "${config_file}: ${setting}":
        value => $value,
        tag   => $tags,
      }
    }
  }

  # This is a hack
  #file { '/etc/init/neutron-plugin-linuxbridge-agent.conf':
  #  ensure  => present,
  #  owner   => 'root',
  #  group   => 'root',
  #  mode    => '0644',
  #  source  => 'puppet:///modules/cubbystack/neutron/neutron-plugin-linuxbridge-agent.conf',
  #  tag     => $tags,
  #  notify  => Service[$::cubbystack::params::neutron_plugin_linuxbridge_service_name],
  #  require => Package[$::cubbystack::params::neutron_plugin_linuxbridge_package_name],
  #}

  cubbystack::functions::generic_service { 'neutron-plugin-linuxbridge':
    service_enable => $service_enable,
    service_ensure => $service_ensure,
    package_ensure => $package_ensure,
    package_name   => $::cubbystack::params::neutron_plugin_linuxbridge_package_name,
    service_name   => $::cubbystack::params::neutron_plugin_linuxbridge_service_name,
    tags           => $tags,
  }

}
