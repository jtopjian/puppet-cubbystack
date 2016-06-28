# == Class: cubbystack::designate::pool
#
# Configures the pool.json file
#
# === Parameters
#
# [*settings*]
#   A hash of key => value settings to go in pool.json
#
# [*config_file*]
#   The path to pool.json
#   Defaults to /etc/designate/pool.json
#
class cubbystack::designate::pool (
  $settings,
  $config_file    = '/etc/designate/pools.yaml',
) {
  include ::cubbystack::params

  ## Meta settings and globals
  $tags = ['openstack', 'designate', 'designate-pool']

  # Make sure Glance is installed before any configuration happens
  # Make sure Glance Registry is configured before the service starts
  Package['designate'] -> Cubbystack_config<| tag == 'designate-pool' |>

  File {
    ensure  => present,
    owner   => 'designate',
    group   => 'designate',
    mode    => '0640',
    tag     => $tags,
    notify  => Exec['Pool Reload'],
    require => Package['designate'],
  }

  exec { 'Pool Reload':
    command     => "/usr/bin/designate-manage pool update --file ${config_file}",
    refreshonly => true,
  }

  file { "${config_file}":
    ensure  => present,
    owner   => 'designate',
    group   => 'designate',
    mode    => '0640',
    content => template('cubbystack/designate/pools.yaml.erb'),
    require => Class['cubbystack::designate'],
  }
}
