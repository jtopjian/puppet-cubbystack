# == Class: cubbystack::designate::policy
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
#   Defaults to /etc/designate/policy.json
#
# === Example Usage
#
# Please see the `examples` directory.
#
class cubbystack::designate::policy (
  $settings,
  $config_file    = '/etc/designate/policy.json',
) {
  include ::cubbystack::params

  ## Meta settings and globals
  $tags = ['openstack', 'designate', 'designate-policy']

  # Make sure Glance is installed before any configuration happens
  # Make sure Glance Registry is configured before the service starts
  Package['designate'] -> Cubbystack_config<| tag == 'designate-policy' |>

  # Restart designate after any config changes
  Cubbystack_config<| tag == 'designate-policy' |> ~> Service['designate-api']

  File {
    ensure  => present,
    owner   => 'designate',
    group   => 'designate',
    mode    => '0640',
    tag     => $tags,
    notify  => Service['designate-api'],
    require => Package['designate'],
  }

  ## Glance Policy configuration
  file { $config_file:
    content => hash2json($settings),
  }

}
