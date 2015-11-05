# == Class: cubbystack::trove::taskmanager
#
# Configures the trove-taskmanager
#
# === Parameters
#
# [*package_ensure*]
#   The status of the trove-taskmanager package
#   Defaults to latest
#
# [*service_enable*]
#   The status of the trove-taskmanager service
#   Defaults to true
#
# [*settings*]
#   A hash of key => value settings to go in trove-taskmanager.conf
#
# [*config_file*]
#   The path to trove-taskmanager.conf
#   Defaults to /etc/trove/trove-taskmanager.conf
#
class cubbystack::trove::taskmanager (
  $settings,
  $package_ensure = latest,
  $service_enable = true,
  $config_file    = '/etc/trove/trove-taskmanager.conf',
) {

  include ::cubbystack::params

  ## Meta settings and globals
  $tags = ['openstack', 'trove', 'trove-taskmanager']

  # Make sure Trove Taskmanager is installed before any configuration begins
  # Make sure Trove Taskmanager is configured before the service starts
  Package<| tag == 'trove' |> -> Cubbystack_config<| tag == 'trove-taskmanager' |>
  Package<| tag == 'trove' |> -> File<| tag == 'trove-taskmanager' |>
  Cubbystack_config<| tag == 'trove-taskmanager' |> -> Service['trove-taskmanager']

  # Restart trove-taskmanager after any config changes
  Cubbystack_config<| tag == 'trove-taskmanager' |> ~> Service['trove-taskmanager']

  File {
    ensure => present,
    owner  => 'trove',
    group  => 'trove',
    mode   => '0640',
    tag    => $tags,
    notify => Service['trove-taskmanager'],
  }

  ## Trove Taskmanager configuration
  file { $config_file: }

  # Configure the taskmanager service
  $settings.each |$setting, $value| {
    cubbystack_config { "${config_file}: ${setting}":
      value => $value,
      tag   => $tags,
    }
  }

  cubbystack::functions::generic_service { 'trove-taskmanager':
    service_enable => $service_enable,
    package_ensure => $package_ensure,
    package_name   => $::cubbystack::params::trove_taskmanager_package_name,
    service_name   => $::cubbystack::params::trove_taskmanager_service_name,
    tags           => $tags,
  }

}
