# == Class: cubbystack::swift::internal-client
#
# Configures the swift-internal-client package and internal-client.conf
#
# === Parameters
#
# [*settings*]
#   A hash of key => value settings to go in internal-client.conf
#
# [*package_ensure*]
#   The status of the swift-internal-client package
#   Defaults to latest
#
# [*service_enable*]
#   The status of the swift-internal-client service.
#   Defaults to true
#
# [*config_file*]
#   The path to internal-client.conf
#   Defaults to /etc/swift/internal-client.conf
#
class cubbystack::swift::internal_client (
  $settings,
  $config_file    = '/etc/swift/internal-client.conf',
) {

  include ::cubbystack::params

  ## Meta settings and globals
  $tags = ['cubbystack_openstack', 'cubbystack_swift', 'swift-internal-client']

  # Restart swift services if the configuration changes
  Cubbystack_config<| tag == 'swift-internal-client' |>  ~> Exec['cubbystack restart swift']

  # internal-client settings
  $settings.each |$setting, $value| {
    cubbystack_config { "${config_file}: ${setting}":
      value => $value,
      tag   => $tags,
    }
  }

}
