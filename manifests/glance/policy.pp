# == Class: cubbystack::glance::policy
#
# Configures the policy.json file
#
# === Parameters
#
# [*settings*]
#   A hash of key => value settings to go in policy.json
#
# [*config_file*]
#   The path to policy.json
#   Defaults to /etc/glance/policy.json
#
class cubbystack::glance::policy (
  $settings,
  $config_file    = '/etc/glance/policy.json',
) {
  include ::cubbystack::params

  ## Meta settings and globals
  $tags = ['cubbystack_openstack', 'cubbystack_glance']

  # Make sure Glance is installed before any configuration happens
  # Make sure Glance Registry is configured before the service starts
  Package['glance'] -> Cubbystack_config<| tag == 'cubbystack_glance' |>

  # Restart glance after any config changes
  Cubbystack_config<| tag == 'cubbystack_glance' |> ~> Service['glance-api']

  File {
    ensure  => present,
    owner   => 'glance',
    group   => 'glance',
    mode    => '0640',
    tag     => $tags,
    notify  => Service['glance-api'],
    require => Package['glance'],
  }

  ## Glance Policy configuration
  file { $config_file:
    content => hash2json($settings),
  }

}
