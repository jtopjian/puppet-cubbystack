# == Class: cubbystack::nova::keystone
#
# Configures keystone authentication for nova
#
# === Parameters
#
# [*settings*]
#   A hash of key => value settings to go in ap-paste.ini
#
# === Example Usage
#
# Please see the `manifests/examples` directory.
#
class cubbystack::nova::keystone (
  $settings
) {
  $settings.each { |$setting, $value|
    nova_paste_api_ini { $setting:
      value => $value,
    }
  }
}
