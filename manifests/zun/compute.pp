# == Class: cubbystack::zun::compute
#
# Configures the zun-compute package and service
#
# === Parameters
#
# [*service_enable*]
#   The status of the zun-compute service
#   Defaults to true
#
# [*service_ensure*]
#   The run status of the zun-compute service
#   Defaults to running
#
class cubbystack::zun::compute (
  $service_enable = true,
  $service_ensure = 'running',
) {

  contain ::cubbystack::zun

  file { '/etc/systemd/system/zun-compute.service':
    ensure => present,
    owner  => 'zun',
    group  => 'zun',
    mode   => '0640',
    source => 'puppet:///modules/cubbystack/zun/zun-compute.service',
    tag    => $::cubbystack::zun::tags,
  }

  service { 'zun-compute':
    ensure  => $service_ensure,
    enable  => $service_enable,
    tag     => $::cubbystack::zun::tags,
    require => File['/etc/systemd/system/zun-compute.service'],
  }
}
