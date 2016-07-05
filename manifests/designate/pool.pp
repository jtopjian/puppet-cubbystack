# == Class: cubbystack::designate::pool
#
# Configures the pools.yaml file
#
# === Parameters
#
# [*settings*]
#   A hash of key => value settings to go in pools.yaml
#
# [*config_file*]
#   The path to pools.yaml
#   Defaults to /etc/designate/pools.yaml
#
class cubbystack::designate::pool (
  $settings,
  $config_file    = '/etc/designate/pools.yaml',
) {
  include ::cubbystack::params

  ## Meta settings and globals
  $tags = ['openstack', 'designate', 'designate-pool']

  Package['designate'] -> Cubbystack_config<| tag == 'designate-pool' |>
  Exec['Pool Reload']  -> Service<| tag == 'designate' |>

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
