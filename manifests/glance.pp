# == Class: cubbystack::glance
#
# Configures the glance package
#
# === Parameters
#
# [*package_ensure*]
#   The status of the glance-common package
#   Defaults to latest
#
class cubbystack::glance (
  $package_ensure = latest
) {

  include ::cubbystack::params

  ## Meta settings and globals
  # Default tags
  $tags = ['cubbystack_openstack', 'cubbystack_glance']

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
    ensure => $package_ensure,
    name   => $::cubbystack::params::glance_package_name,
    tag    => $tags,
  }

  # Glance files and directories
  file { '/etc/glance':
    ensure  => directory,
    recurse => true,
  }
  file { '/var/log/glance':
    ensure  => directory,
    recurse => true,
  }

}
