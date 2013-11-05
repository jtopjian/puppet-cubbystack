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
# [*purge_config*]
#   Whether or not to purge all settings in glance-api.conf
#   Defaults to true
#
# === Example Usage
#
# Please see the `examples` directory.
#
class cubbystack::glance::api (
  $settings,
  $service_enable = true,
  $purge_config   = true,
) {

  include ::cubbystack::params

  ## Meta settings and globals
  # Make sure Glance is installed before any configuration happens
  # Make sure Glance API is configured before the service starts
  Package['glance']     -> Glance_api_config<||>
  Glance_api_config<||> -> Service['glance-api']

  # Restart glance after any config changes
  Glance_api_config<||> ~> Service['glance-api']

  # Purge all resources in the Glance config files
  resources { 'glance_api_config':
    purge => $purge_config,
  }

  # Default tags
  $tags = ['openstack', 'glance', 'glance-api']

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
  file { '/etc/glance/glance-api.conf': }

  # Configure the API service
  $settings.each { |$setting, $value|
    glance_api_config { $setting:
      value => $value,
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
