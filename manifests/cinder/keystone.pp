# == Class: cubbystack::cinder::keystone
#
# Configures keystone authentication for cinder
#
# === Parameters
#
# [*settings*]
#   A hash of key => value settings to go in ap-paste.ini
#
# [*config_paste_path*]
#   The path to api-paste.ini
#   Defaults to /etc/cinder/api-paste.ini
#
# [*purge_paste_config*]
#   Whether or not to purge all settings in api-paste.ini
#   Defaults to false
#
# === Example Usage
#
# Please see the `examples` directory.
#
class cubbystack::cinder::keystone (
  $settings,
  $purge_config = false,
) {

  ## Meta settings and globals
  # Make sure cinder is installed before configuration begins
  Package<| tag == 'cinder' |> -> Cinder_api_paste_ini<||>
  Cinder_api_paste_ini<||>     -> Service<| tag == 'cinder' |>

  # Restart cinder services whenever api-paste.ini has been changed
  Cinder_api_paste_ini<||> ~> Service<| tag == 'cinder' |>

  resources { 'cinder_api_paste_ini':
    purge => $purge_resources,
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

  file { '/etc/cinder/api-paste.ini': }

  $settings.each { |$setting, $value|
    cinder_api_paste_ini { $setting:
      value => $value,
    }
  }
}
