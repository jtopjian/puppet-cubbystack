# == Class: cubbystack::cinder::keystone
#
# Configures keystone authentication for cinder
#
# === Parameters
#
# [*settings*]
#   A hash of key => value settings to go in ap-paste.ini
#
# [*config_file*]
#   The path to api-paste.ini
#   Defaults to /etc/cinder/api-paste.ini
#
class cubbystack::cinder::keystone (
  $settings,
  $config_file = '/etc/cinder/api-paste.ini',
) {

  ## Meta settings and globals
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

  file { $config_file: }

  $settings.each |$setting, $value| {
    cubbystack_config { "${config_file}: ${setting}":
      value => $value,
      tag   => $tags,
    }
  }
}
