# == Class: cubbystack::nova::keystone
#
# Configures keystone authentication for nova
#
# === Parameters
#
# [*settings*]
#   A hash of key => value settings to go in ap-paste.ini
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
  $purge_config = false,
) {

  ## Meta settings and globals
  # Make sure nova is installed before configuration begins
  Package<| tag == 'nova' |> -> Nova_paste_api_ini<||>
  Nova_paste_api_ini<||>     -> Service<| tag == 'nova' |>

  # Restart nova services whenever api-paste.ini has been changed
  Nova_paste_api_ini<||> ~> Service<| tag == 'nova' |>

  resources { 'nova_paste_api_ini':
    purge => $purge_config,
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

  file { '/etc/nova/api-paste.ini': }

  $settings.each { |$setting, $value|
    nova_paste_api_ini { $setting:
      value => $value,
    }
  }
}
