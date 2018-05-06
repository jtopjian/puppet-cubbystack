# == Class: cubbystack::swift::proxy
#
# Configures the swift-proxy package and proxy-server.conf
#
# === Parameters
#
# [*settings*]
#   A hash of key => value settings to go in proxy-server.conf
#
# [*package_ensure*]
#   The status of the swift-proxy package
#   Defaults to present
#
# [*service_enable*]
#   The status of the swift-proxy service.
#   Defaults to true
#
# [*config_file*]
#   The path to proxy-server.conf
#   Defaults to /etc/swift/proxy-server.conf
#
class cubbystack::swift::proxy (
  $settings,
  $package_ensure = present,
  $service_enable = true,
  $config_file    = '/etc/swift/proxy-server.conf',
) {

  contain ::cubbystack::params

  # Meta settings and globals
  $tags = ['cubbystack_openstack', 'cubbystack_swift', 'swift-proxy']

  # Restart proxy-server if the configuration changes
  Cubbystack_config<| tag == 'swift-proxy' |> ~> Service<| tag == 'swift-proxy' |>

  # proxy settings
  $settings.each |$setting, $value| {
    cubbystack_config { "${config_file}: ${setting}":
      value => $value,
      tag   => $tags,
    }
  }

  # Install the swift-proxy package and manage its service
  cubbystack::functions::generic_service { 'swift-proxy':
    service_enable => $service_enable,
    package_ensure => $package_ensure,
    package_name   => $::cubbystack::params::swift_proxy_package_name,
    service_name   => $::cubbystack::params::swift_proxy_service_name,
    tags           => $tags,
  }
}
