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
# [*config_file*]
#   The path to glance-cache.conf
#   Defaults to /etc/glance/glance-cache.conf.
#
class cubbystack::glance::cache (
  $settings,
  $config_file = '/etc/glance/glance-cache.conf',
) {

  include ::cubbystack::params

  ## Meta settings and globals
  $tags = ['cubbystack_openstack', 'cubbystack_glance']

  # Make sure Glance is installed before any configuration happens
  Package['glance'] -> Cubbystack_config<| tag == 'cubbystack_glance' |>

  File {
    ensure  => present,
    owner   => 'glance',
    group   => 'glance',
    mode    => '0640',
    tag     => $tags,
    require => Package['glance'],
  }

  ## Glance cache configuration
  file { $config_file: }

  # Configure the Cache service
  $settings.each |$setting, $value| {
    cubbystack_config { "${config_file}: ${setting}":
      value => $value,
      tag   => $tags,
    }
  }

}
