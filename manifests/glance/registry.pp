# == Class: cubbystack::glance::registry
#
# Configures the glance-registry.conf file
#
# === Parameters
#
# [*config_file*]
#   The path to a puppet-hosted static config file
#   Required
#
# [*settings*]
#   A hash of key => value settings to go in glance-registry.conf
#
# [*service_enable*]
#   The status of the glance-registry service
#   Defaults to true
#
# [*purge_config*]
#   Whether or not to purge all settings in glance-registry.conf
#   Defaults to true
#
# === Example Usage
#
# Please see the `examples` directory.
#
class cubbystack::glance::registry (
  $settings,
  $service_enable = true,
  $purge_config   = true,
) {

  include ::cubbystack::params

  ## Meta settings and globals
  # Make sure Glance is installed before any configuration happens
  # Make sure Glance Registry is configured before the service starts
  Package['glance']          -> Glance_registry_config<||>
  Glance_registry_config<||> -> Service['glance-registry']

  # Restart glance after any config changes
  Glance_registry_config<||> ~> Service['glance-registry']

  # Purge all resources in the Glance config files
  resources { 'glance_registry_config':
    purge => $purge_resources,
  }

  # Default tags
  $tags = ['openstack', 'glance', 'glance-registry']

  File {
    ensure  => present,
    owner   => 'glance',
    group   => 'glance',
    mode    => '0640',
    tag     => $tags,
    notify  => Service['glance-registry'],
    require => Package['glance'],
  }

  ## Glance Registry configuration
  file { '/etc/glance/glance-registry.conf': }

  # Configure the Registry service
  $settings.each { |$setting, $value|
    glance_registry_config { $setting:
      value => $value,
    }
  }

  ## Glance Registry service
  if ($service_enable) {
    $service_ensure = 'running'
  } else {
    $service_ensure = 'stopped'
  }

  service { 'glance-registry':
    name       => $::cubbystack::params::glance_registry_service_name,
    ensure     => $service_ensure,
    enable     => $service_enable,
    hasstatus  => true,
    hasrestart => true,
    tag        => $tags,
    provider   => $::cubbystack::params::service_provider,
    require    => Package['glance'],
  }

}
