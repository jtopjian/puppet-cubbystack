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
class cubbystack::designate::policy (
  $settings,
  $config_file    = '/etc/designate/policy.json',
) {
  contain ::cubbystack::params

  ## Meta settings and globals
  $tags = ['cubbystack_openstack', 'cubbystack_designate']

  # Make sure Designate is installed before any configuration happens
  # Make sure Designate Registry is configured before the service starts
  Package['designate'] -> Cubbystack_config<| tag == 'cubbystack_designate' |>

  # Restart designate after any config changes
  Cubbystack_config<| tag == 'cubbystack_designate' |> ~> Service['designate-api']

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
