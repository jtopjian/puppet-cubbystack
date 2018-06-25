# == Class: cubbystack::senlin::engine
#
# Configures the senlin-engine package and service
#
# === Parameters
#
# [*service_enable*]
#   The status of the senlin-engine service
#   Defaults to true
#
# [*service_ensure*]
#   The run status of the senlin-engine service
#   Defaults to running
#
class cubbystack::senlin::engine (
  $service_enable = true,
  $service_ensure = 'running',
) {

  contain ::cubbystack::senlin

  file { '/etc/systemd/system/senlin-engine.service':
    ensure => present,
    owner  => 'senlin',
    group  => 'senlin',
    mode   => '0640',
    source => 'puppet:///modules/cubbystack/senlin/senlin-engine.service',
    tag    => $::cubbystack::senlin::tags,
  }

  service { 'senlin-engine':
    ensure  => $service_ensure,
    enable  => $service_enable,
    tag     => $::cubbystack::senlin::tags,
    require => File['/etc/systemd/system/senlin-engine.service'],
  }
}
