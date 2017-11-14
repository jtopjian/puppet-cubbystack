# == Class: cubbystack::trove::api_paste
#
# Configures keystone authentication for trove
#
# === Parameters
#
# [*config_file*]
#   The path to trove's api-paste.ini file
#   Defaults to /etc/trove/api-paste.ini
#
# [*purge_config*]
#   Whether or not to purge all settings in api-paste.ini
#   Defaults to false
#
class cubbystack::trove::api_paste (
  $settings,
  $config_file = '/etc/trove/api-paste.ini',
) {

  ## Meta settings and globals
  $tags = ['cubbystack_openstack', 'cubbystack_trove']

  # Global file attributes
  File {
    ensure  => present,
    owner   => 'trove',
    group   => 'trove',
    mode    => '0640',
    tag     => $tags,
    require => Package['trove-api'],
  }

  $settings.each |$setting, $value| {
    cubbystack_config { "${config_file}: ${setting}":
      value => $value,
      tag   => $tags,
    }
  }
}
