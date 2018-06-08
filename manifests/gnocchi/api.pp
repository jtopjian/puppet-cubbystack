# == Class: cubbystack::gnocchi::api
#
# Configures the gnocchi-api package and service
#
# === Parameters
#
# [*service_enable*]
#   The status of the gnocchi-api service
#   Defaults to true
#
# [*service_ensure*]
#   The run status of the gnocchi-api service
#   Defaults to running
#
class cubbystack::gnocchi::api (
  $service_enable = true,
  $service_ensure = 'running',
) {

  contain ::cubbystack::gnocchi

  file { '/etc/apache2/sites-enabled/10-gnocchi-api.conf':
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode   => '0640',
    source => 'puppet:///modules/cubbystack/gnocchi/gnocchi-api.conf',
    notify => Service['apache2'],
    tag    => $::cubbystack::gnocchi::tags,
  }
}
