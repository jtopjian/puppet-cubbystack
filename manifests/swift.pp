# == Class: cubbystack::swift
#
# Configures the swift package and swift.conf
#
# === Parameters
#
# [*settings*]
#   A hash of key => value settings to go in swift.conf
#   Required.
#
# [*config_file*]
#   The path to swift.conf
#   Defaults to /etc/swift/swift.conf
#
# [*package_ensure*]
#   The state of the swift package.
#   Defaults to present.
#
class cubbystack::swift (
  $settings,
  $package_ensure = present,
  $config_file    = '/etc/swift/swift.conf',
  $purge_config   = true,
) {

  include ::cubbystack::params

  # Meta and globals
  $tags = 'cubbystack_swift'

  # Make sure swift.conf exists before any configuration happens
  Package<| tag == 'cubbystack_swift' |> -> Cubbystack_config<| tag == 'cubbystack_swift' |>
  Cubbystack_config<| tag == 'cubbystack_swift' |> -> Service<| tag == 'cubbystack_swift' |>

  # Install the swift package
  package { 'swift':
    ensure => $package_ensure,
    name   => $::cubbystack::params::swift_package_name,
    tag    => $tags,
  }

  # Global file attributes
  File {
    ensure  => present,
    owner   => 'swift',
    group   => 'swift',
    mode    => '0640',
    require => Package['swift'],
  }

  $swift_directories = ['/etc/swift', '/etc/swift/backups', '/var/lib/swift']
  file { $swift_directories:
    ensure  => directory,
    recurse => true;
  }

  # Configure the swift.conf file
  $settings.each |$setting, $value| {
    cubbystack_config { "${config_file}: ${setting}":
      value => $value,
      tag   => $tags,
    }
  }
}
