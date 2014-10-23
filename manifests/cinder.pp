# == Class: cubbystack::cinder
#
# Configures the cinder-common package and cinder.conf
#
# === Parameters
#
# [*settings*]
#   A hash of key => value settings to go in cinder.conf
#
# [*package_ensure*]
#   The status of the cinder-common package
#   Defaults to latest
#
# [*purge_resources*]
#   Whether or not to purge all settings in cinder.conf
#   Defaults to true
#
# === Example Usage
#
# Please see the `manifests/examples` directory.
#
class cubbystack::cinder (
  $settings,
  $package_ensure  = latest,
  $purge_resources = true
) {

  include ::cubbystack::params

  ## Meta settings and globals

  # Make sure cinder is installed before configuration begins
  Package<| tag == 'cinder' |> -> Cinder_config<||>
  Cinder_config<||>            -> Service<| tag == 'cinder' |>

  # Restart cinder services whenever cinder.conf has been changed
  Cinder_config<||>             ~> Service<| tag == 'cinder' |>

  # Purge all resources in cinder.conf
  if ($purge_resources) {
    resources { 'cinder_config':
      purge => true,
    }
  }

  # Default tags to use
  $tags = ['openstack', 'cinder']

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
  file { '/var/log/cinder': ensure => directory }
  file { '/etc/cinder/cinder.conf': }
  file { '/etc/cinder/api-paste.ini': }

  ## Configure cinder.conf

  $settings.each { |$setting, $value|
    cinder_config { $setting:
      value => $value,
    }
  }


}
