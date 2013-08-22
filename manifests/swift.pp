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
# [*package_ensure*]
#   The state of the swift package.
#   Defaults to latest.
#
# === Example Usage
#
# Please see the `manifests/examples` directory.
#
class cubbystack::swift (
  $swift_hash_path_suffix,
  $package_ensure = latest,
) {

  include ::cubbystack::params

  # Meta and globals
  Package['swift'] -> Swift_config<||>
  $tags = 'swift'

  package { 'swift':
    name   => $::cubbystack::params::swift_package_name,
    ensure => $package_ensure,
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

  swift_config {
    'swift-hash/swift_hash_path_suffix': value => $swift_hash_path_suffix,
  }
}
