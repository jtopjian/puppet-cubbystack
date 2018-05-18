# == Class: cubbystack::zun::wsproxy
#
# Configures the zun-wsproxy package and service
#
# === Parameters
#
# [*service_enable*]
#   The status of the zun-wsproxy service
#   Defaults to true
#
# [*service_ensure*]
#   The run status of the zun-wsproxy service
#   Defaults to running
#
class cubbystack::zun::wsproxy (
  $service_enable = true,
  $service_ensure = 'running',
) {

  contain ::cubbystack::zun

  file { '/etc/systemd/system/zun-wsproxy.service':
    ensure => present,
    owner  => 'zun',
    group  => 'zun',
    mode   => '0640',
    source => 'puppet:///modules/cubbystack/zun/zun-wsproxy.service',
    tag    => $::cubbystack::zun::tags,
  }

  service { 'zun-wsproxy':
    ensure  => $service_ensure,
    enable  => $service_enable,
    tag     => $::cubbystack::zun::tags,
    require => File['/etc/systemd/system/zun-wsproxy.service'],
  }
}
