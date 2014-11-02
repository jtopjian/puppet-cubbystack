# == Class: cubbystack::glance::api
#
# Configures the glance-api.conf file
#
# === Parameters
#
# [*settings*]
#   A hash of key => value settings to go in glance-api.conf
#
# [*service_enable*]
#   The status of the glance-api service
#   Defaults to true
#
# [*config_file*]
#   The path to glance-api.conf
#   Defaults to /etc/glance/glance-api.conf
#
class cubbystack::glance::api (
  $settings,
  $service_enable = true,
  $config_file    = '/etc/glance/glance-api.conf',
) {

  include ::cubbystack::params

  ## Meta settings and globals
  $tags = ['openstack', 'glance', 'glance-api']

  # Make sure Glance is installed before any configuration happens
  # Make sure Glance API is configured before the service starts
  Package['glance'] -> Cubbystack_config<| tag == 'glance-api' |>
  Cubbystack_config<| tag == 'glance-api' |> -> Service['glance-api']

  # Restart glance after any config changes
  Cubbystack_config<| tag == 'glance-api' |> ~> Service['glance-api']

  File {
    ensure  => present,
    owner   => 'glance',
    group   => 'glance',
    mode    => '0640',
    tag     => $tags,
    notify  => Service['glance-api'],
    require => Package['glance'],
  }

  ## Glance API configuration
  file { $config_file: }

  # Configure the API service
  $settings.each |$setting, $value| {
    cubbystack_config { "${config_file}: ${setting}":
      value => $value,
      tag   => $tags,
    }
  }

  ## Glance API service
  if ($service_enable) {
    $service_ensure = 'running'
  } else {
    $service_ensure = 'stopped'
  }

  service { 'glance-api':
    name       => $::cubbystack::params::glance_api_service_name,
    ensure     => $service_ensure,
    enable     => $service_enable,
    hasstatus  => true,
    hasrestart => true,
    tag        => $tags,
    provider   => $::cubbystack::params::service_provider,
    require    => Package['glance'],
  }

}
