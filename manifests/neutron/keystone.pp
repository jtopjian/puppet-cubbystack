# == Class: cubbystack::neutron::keystone
#
# Configures keystone authentication for neutron
#
# === Parameters
#
# [*settings*]
#   A hash of key => value settings to go in ap-paste.ini
#
# [*config_file*]
#   The path to api-paste.ini
#   Defaults to /etc/neutron/api-paste.ini
#
# === Example Usage
#
# Please see the `examples` directory.
#
class cubbystack::neutron::keystone (
  $settings,
  $config_file = '/etc/neutron/api-paste.ini',
) {

  ## Meta settings and globals
  $tags = ['openstack', 'neutron']

  # Global file attributes
  File {
    ensure  => present,
    owner   => 'neutron',
    group   => 'neutron',
    mode    => '0640',
    tag     => $tags,
    require => Package['neutron-common'],
  }

  file { $config_file: }

  $settings.each |$setting, $value| {
    cubbystack_config { "${config_file}: ${setting}":
      value => $value,
      tag   => $tags,
    }
  }
}
