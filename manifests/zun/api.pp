# == Class: cubbystack::zun::api
#
# Configures the zun-api package and service
#
# === Parameters
#
# [*service_enable*]
#   The status of the zun-api service
#   Defaults to true
#
# [*service_ensure*]
#   The run status of the zun-api service
#   Defaults to running
#
class cubbystack::zun::api (
  $service_enable = true,
  $service_ensure = 'running',
) {

  contain ::cubbystack::zun

  file { '/etc/systemd/system/zun-api.service':
    ensure => present,
    owner  => 'zun',
    group  => 'zun',
    mode   => '0640',
    source => 'puppet:///modules/cubbystack/zun/zun-api.service',
    tag    => $::cubbystack::zun::tags,
  }

  service { 'zun-api':
    ensure  => $service_ensure,
    enable  => $service_enable,
    tag     => $::cubbystack::zun::tags,
    require => File['/etc/systemd/system/zun-api.service'],
  }
}
