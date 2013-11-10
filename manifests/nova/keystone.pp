# == Class: cubbystack::nova::keystone
#
# Configures keystone authentication for nova
#
# === Parameters
#
# [*config_file*]
#   The path to nova's api-paste.ini file
#   Defaults to /etc/nova/api-paste.ini
#
# [*purge_config*]
#   Whether or not to purge all settings in api-paste.ini
#   Defaults to false
#
# === Example Usage
#
# Please see the `examples` directory.
#
class cubbystack::nova::keystone (
  $settings,
  $config_file = '/etc/nova/api-paste.ini',
) {

  ## Meta settings and globals
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

  file { $config_file: }

  $settings.each { |$setting, $value|
    cubbystack_config { "${config_file}: ${setting}":
      value => $value,
      tag   => $tags,
    }
  }
}
