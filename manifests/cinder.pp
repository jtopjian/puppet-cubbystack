# == Class: cubbystack::cinder
#
# Configures the cinder-common package and cinder.conf
#
# === Parameters
#
# [*settings*]
#   A hash of key => value settings to go in cinder.conf
#
# [*config_file*]
#   The path to cinder.conf
#   Defaults to /etc/cinder/cinder.conf
#
# [*package_ensure*]
#   The status of the cinder-common package
#   Defaults to latest
#
class cubbystack::cinder (
  $settings,
  $package_ensure = latest,
  $config_file    = '/etc/cinder/cinder.conf',
) {

  include ::cubbystack::params

  ## Meta settings and globals
  $tags = ['openstack', 'cinder']

  # Make sure cinder is installed before configuration begins
  Package<| tag == 'cinder' |> -> Cubbystack_config<| tag == 'cinder' |>
  Cubbystack_config<| tag == 'cinder' |> -> Service<| tag == 'cinder' |>

  # Restart cinder services whenever cinder.conf has been changed
  Cubbystack_config<| tag == 'cinder' |> ~> Service<| tag == 'cinder' |>

  # Global file attributes
  File {
    ensure  => present,
    owner   => 'cinder',
    group   => 'cinder',
    mode    => '0640',
    tag     => $tags,
    require => Package['cinder-common'],
  }

  # cinder-common package
  package { 'cinder-common':
    name   => $::cubbystack::params::cinder_common_package_name,
    ensure => present,
    tag    => $tags,
  }

  ## Cinder configuration files
  file { '/etc/cinder':
    ensure  => directory,
    recurse => true,
  }

  file { '/var/log/cinder': ensure => directory }
  file { $config_file: }

  # Configure cinder.conf
  $settings.each |$setting, $value| {
    cubbystack_config { "${config_file}: ${setting}":
      value => $value,
      tag   => $tags,
    }
  }

}
