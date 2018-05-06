# == Class: cubbystack::murano
#
# Configures the murano-common package and murano.conf
#
# === Parameters
#
# [*settings*]
#   A hash of key => value settings to go in cinder.conf
#
# [*package_ensure*]
#   The status of the murano-common package
#   Defaults to present
#
# [*config_file*]
#   The path to murano.conf
#   Defaults to /etc/murano/murano.conf
#
class cubbystack::murano (
  $settings,
  $package_ensure = present,
  $config_file    = '/etc/murano/murano.conf',
) {

  contain ::cubbystack::params

  ## Meta settings and globals
  $tags = ['cubbystack-openstack', 'cubbystack-murano']

  # Make sure murano is installed before configuration begins
  Package<| tag == 'cubbystack-murano' |> -> Cubbystack_config<| tag == 'cubbystack-murano' |>
  Cubbystack_config<| tag == 'cubbystack-murano' |> -> Service<| tag == 'cubbystack-murano' |>

  # Restart murano services whenever murano.conf has been changed
  Cubbystack_config<| tag == 'cubbystack-murano' |> ~> Service<| tag == 'cubbystack-murano' |>

  # Global file attributes
  File {
    ensure  => present,
    owner   => 'murano',
    group   => 'murano',
    mode    => '0640',
    tag     => $tags,
    require => Package['murano-common'],
  }

  # murano-common package
  package { 'murano-common':
    name   => $::cubbystack::params::murano_common_package_name,
    ensure => present,
    tag    => $tags,
  }

  ## Murano configuration files
  file { '/var/log/murano':
    ensure  => directory,
    recurse => true,
  }

  file { '/etc/murano':
    ensure  => directory,
    recurse => true,
  }

  file { $config_file: }

  ## Configure murano.conf
  $settings.each |$setting, $value| {
    cubbystack_config { "${config_file}: ${setting}":
      value => $value,
      tag   => $tags,
    }
  }

}
