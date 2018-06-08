# == Class: cubbystack::gnocchi::metricd
#
# Configures the gnocchi-metricd package and service
#
# === Parameters
#
# [*service_enable*]
#   The status of the gnocchi-metricd service
#   Defaults to true
#
# [*service_ensure*]
#   The run status of the gnocchi-metricd service
#   Defaults to running
#
class cubbystack::gnocchi::metricd (
  $service_enable = true,
  $service_ensure = 'running',
) {

  contain ::cubbystack::gnocchi

  file { '/etc/systemd/system/gnocchi-metricd.service':
    ensure => present,
    owner  => 'gnocchi',
    group  => 'gnocchi',
    mode   => '0640',
    source => 'puppet:///modules/cubbystack/gnocchi/gnocchi-metricd.service',
    tag    => $::cubbystack::gnocchi::tags,
  }

  service { 'gnocchi-metricd':
    ensure  => $service_ensure,
    enable  => $service_enable,
    tag     => $::cubbystack::gnocchi::tags,
    require => File['/etc/systemd/system/gnocchi-metricd.service'],
  }
}
