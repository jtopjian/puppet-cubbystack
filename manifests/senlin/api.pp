# == Class: cubbystack::senlin::api
#
# Configures the senlin-api package and service
#
# === Parameters
#
# [*service_enable*]
#   The status of the senlin-api service
#   Defaults to true
#
# [*service_ensure*]
#   The run status of the senlin-api service
#   Defaults to running
#
class cubbystack::senlin::api (
  $service_enable = true,
  $service_ensure = 'running',
) {

  contain ::cubbystack::senlin

  file { '/etc/systemd/system/senlin-api.service':
    ensure => present,
    owner  => 'senlin',
    group  => 'senlin',
    mode   => '0640',
    source => 'puppet:///modules/cubbystack/senlin/senlin-api.service',
    tag    => $::cubbystack::senlin::tags,
  }

  service { 'senlin-api':
    ensure  => $service_ensure,
    enable  => $service_enable,
    tag     => $::cubbystack::senlin::tags,
    require => File['/etc/systemd/system/senlin-api.service'],
  }
}
