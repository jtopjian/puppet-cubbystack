# == Class: cubbystack::swift
#
# Configures the swift package and swift.conf
#
# === Parameters
#
# [*swift_hash_path_suffix*]
#   The hash path suffix to use.
#   Required.
#
# [*config_path*]
#   The path to swift.conf
#   Defaults to /etc/swift/swift.conf
#
# [*purge_config*]
#   Whether or not to purge all settings in swift.conf
#   Defaults to true
#
# [*package_ensure*]
#   The state of the swift package.
#   Defaults to latest.
#
# === Example Usage
#
# Please see the `examples` directory.
#
class cubbystack::swift (
  $swift_hash_path_suffix,
  $package_ensure = latest,
  $config_path    = '/etc/swift/swift.conf',
  $purge_config   = true,
) {

  include ::cubbystack::params

  # Meta and globals
  Package['swift'] -> Cubbystack_config<| tag == 'swift' |>
  $tags = 'swift'

  package { 'swift':
    name   => $::cubbystack::params::swift_package_name,
    ensure => $package_ensure,
  }

  # Purge swift resources
  if ($purge_config) {
    resources { 'cubbystack_config':
      purge => true,
      tag   => 'swift',
    }
  }

  File {
    ensure  => present,
    owner   => 'swift',
    group   => 'swift',
    mode    => '0640',
    require => Package['swift'],
  }

  $swift_directories = ['/etc/swift', '/var/lib/swift']
  file { $swift_directories:
    ensure  => directory,
    recurse => true;
  }

  cubbystack_config { 'swift-hash/swift_hash_path_suffix':
    value => $swift_hash_path_suffix,
    path  => $config_path,
    tag   => 'swift',
  }
}
