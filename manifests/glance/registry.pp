# == Class: cubbystack::glance::registry
#
# Configures the glance-registry.conf file
#
# === Parameters
#
# [*settings*]
#   A hash of key => value settings to go in glance-registry.conf
#
# [*service_enable*]
#   The status of the glance-registry service
#   Defaults to true
#
# [*config_file*]
#   The path to glance-registry.conf
#   Defaults to /etc/glance/glance-registry.conf
#
class cubbystack::glance::registry (
  $settings,
  $service_enable = true,
  $config_file    = '/etc/glance/glance-registry.conf',
) {

  contain ::cubbystack::params

  ## Meta settings and globals
  $tags = ['cubbystack_openstack', 'cubbystack_glance']

  # Make sure Glance is installed before any configuration happens
  # Make sure Glance Registry is configured before the service starts
  Package['glance'] -> Cubbystack_config<| tag == 'cubbystack_glance' |>
  Cubbystack_config<| tag == 'cubbystack_glance' |> -> Service['glance-registry']

  # Restart glance after any config changes
  Cubbystack_config<| tag == 'cubbystack_glance' |> ~> Service['glance-registry']

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
  file { $config_file: }

  # Configure the Registry service
  $settings.each |$setting, $value| {
    cubbystack_config { "${config_file}: ${setting}":
      value => $value,
      tag   => $tags,
    }
  }

  ## Glance Registry service
  if $service_enable {
    $service_ensure = 'running'
  } else {
    $service_ensure = 'stopped'
  }

  service { 'glance-registry':
    ensure     => $service_ensure,
    enable     => $service_enable,
    name       => $::cubbystack::params::glance_registry_service_name,
    hasstatus  => true,
    hasrestart => true,
    tag        => $tags,
    provider   => $::cubbystack::params::service_provider,
    require    => Package['glance'],
  }

}
