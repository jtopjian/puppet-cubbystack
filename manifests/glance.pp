# == Class: cubbystack::glance
#
# Configures the cinder package
#
# === Parameters
#
# [*package_ensure*]
#   The status of the cinder-common package
#   Defaults to latest
#
# === Example Usage
#
# Please see the `examples` directory.
#
class cubbystack::glance (
  $package_ensure = latest
) {

  include ::cubbystack::params

  ## Meta settings and globals
  # Default tags
  $tags = ['openstack', 'glance']

  File {
    ensure  => present,
    owner   => 'glance',
    group   => 'glance',
    mode    => '0640',
    tag     => $tags,
    require => Package['glance'],
  }

  ## Glance Package installation
  package { 'glance':
    name   => $::cubbystack::params::glance_package_name,
    ensure => $package_ensure,
    tag    => $tags,
  }

  # Glance files and directories
  file { '/etc/glance':
    ensure  => directory,
    recurse => true,
  }

}
