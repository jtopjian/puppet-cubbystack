# == Class: cubbystack::glance::cache
#
# Configures the glance-cache.conf file
#
# === Parameters
#
# [*settings*]
#   A hash of key => value settings to go in glance-cache.conf
#
# [*service_enable*]
#   The status of the glance-cache service
#   Defaults to true
#
# [*purge_config*]
#   Whether or not to purge all settings in glance-cache.conf
#   Defaults to true
#
# === Example Usage
#
# Please see the `examples` directory.
#
class cubbystack::glance::cache (
  $settings,
  $purge_config = true,
) {

  include ::cubbystack::params

  ## Meta settings and globals
  # Make sure Glance is installed before any configuration happens
  Package['glance'] -> Glance_cache_config<||>

  # Purge all resources in the Glance config files
  resources { 'glance_cache_config':
    purge => $purge_resources,
  }

  # Default tags
  $tags = ['openstack', 'glance', 'glance-cache']

  File {
    ensure  => present,
    owner   => 'glance',
    group   => 'glance',
    mode    => '0640',
    tag     => $tags,
    require => Package['glance'],
  }

  ## Glance cache configuration
  file { '/etc/glance/glance-cache.conf': }

  # Configure the Cache service
  $settings.each { |$setting, $value|
    glance_cache_config { $setting:
      value => $value,
    }
  }

}
