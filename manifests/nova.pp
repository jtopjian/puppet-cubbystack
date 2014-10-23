# == Class: cubbystack::nova
#
# Configures the nova-common package and nova.conf
#
# === Parameters
#
# [*settings*]
#   A hash of key => value settings to go in cinder.conf
#
# [*package_ensure*]
#   The status of the nova-common package
#   Defaults to latest
#
# [*purge_resources*]
#   Whether or not to purge all settings in nova.conf
#   Defaults to true
#
# === Example Usage
#
# Please see the `manifests/examples` directory.
#
class cubbystack::nova (
  $settings,
  $package_ensure  = latest,
  $purge_resources = true
) {

  include ::cubbystack::params

  ## Meta settings and globals

  # Make sure nova is installed before configuration begins
  Package<| tag == 'nova' |> -> Nova_config<||>
  Nova_config<||>            -> Service<| tag == 'nova' |>

  # Restart nova services whenever nova.conf has been changed
  Nova_config<||>             ~> Service<| tag == 'nova' |>

  # Purge all resources in nova.conf
  if ($purge_resources) {
    resources { 'nova_config':
      purge => true,
    }
  }

  # Default tags to use
  $tags = ['openstack', 'nova']

  # Global file attributes
  File {
    ensure  => present,
    owner   => 'nova',
    group   => 'nova',
    mode    => '0640',
    tag     => $tags,
    require => Package['nova-common'],
  }

  # nova-common package
  package { 'nova-common':
    name   => $::cubbystack::params::nova_common_package_name,
    ensure => present,
    tag    => $tags,
  }

  ## Nova configuration files
  file { '/var/log/nova':
    ensure  => directory,
    recurse => true,
  }
  file { '/etc/nova/nova.conf': }
  file { '/etc/nova/api-paste.ini': }
  # nova-manage insists on 0644
  file { '/var/log/nova/nova-manage.log':
    mode => '0644',
  }

  ## Configure nova.conf
  $settings.each { |$setting, $value|
    nova_config { $setting:
      value => $value,
    }
  }

}
