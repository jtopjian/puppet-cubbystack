# == Class: cubbystack::trove::conductor
#
# Configures the trove-conductor.conf file
#
# === Parameters
#
# [*settings*]
#   A hash of key => value settings to go in trove-conductor.conf
#
# [*service_enable*]
#   The status of the trove-conductor service
#   Defaults to true
#
# [*config_file*]
#   The path to trove-conductor.conf
#   Defaults to /etc/trove/trove-conductor.conf
#
class cubbystack::trove::conductor (
  $settings,
  $service_enable = true,
  $config_file    = '/etc/trove/trove-conductor.conf',
) {

  include ::cubbystack::params

  ## Meta settings and globals
  $tags = ['cubbystack_openstack', 'cubbystack_trove', 'trove-conductor']

  # Make sure Trove is installed before any configuration happens
  # Make sure Trove Conductor is configured before the service starts
  Package['trove-api'] -> Cubbystack_config<| tag == 'trove-conductor' |>
  Cubbystack_config<| tag == 'trove-conductor' |> -> Service['trove-conductor']

  # Restart trove after any config changes
  Cubbystack_config<| tag == 'trove-conductor' |> ~> Service['trove-conductor']

  File {
    ensure  => present,
    owner   => 'trove',
    group   => 'trove',
    mode    => '0640',
    tag     => $tags,
    notify  => Service['trove-conductor'],
    require => Package['trove-api'],
  }

  ## Trove Conductor configuration
  file { $config_file: }

  # Configure the Conductor service
  $settings.each |$setting, $value| {
    cubbystack_config { "${config_file}: ${setting}":
      value => $value,
      tag   => $tags,
    }
  }

  ## Trove Conductor service
  if $service_enable {
    $service_ensure = 'running'
  } else {
    $service_ensure = 'stopped'
  }

  service { 'trove-conductor':
    ensure     => $service_ensure,
    enable     => $service_enable,
    name       => $::cubbystack::params::trove_conductor_service_name,
    hasstatus  => true,
    hasrestart => true,
    tag        => $tags,
    provider   => $::cubbystack::params::service_provider,
    require    => Package['trove-api'],
  }

}
