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
#   Defaults to latest
#
# [*service_enable*]
#   The status of the swift-proxy service.
#   Defaults to true
#
# [*purge_resources*]
#   Whether or not to purge all settings in proxy-server.conf
#   Defaults to true
#
# === Example Usage
#
# Please see the `manifests/examples` directory.
#
class cubbystack::swift::proxy (
  $settings,
  $purge_resources = true,
  $package_ensure  = latest,
  $service_enable  = true
) {

  include ::cubbystack::params
  include ::cubbystack::swift

  # Make sure swift is installed before configuration happens
  # Make sure swift is configured before the service starts
  Package<| tag == 'swift' |> -> Swift_proxy_config<||>
  Swift_proxy_config<||>      -> Service<| tag == 'swift' |>

  # Restart swift if the configuration changes
  Swift_proxy_config<||>      ~> Service<| tag == 'swift' |>

  # Purge all resources in proxy-server.conf?
  resources { 'swift_proxy_config':
    purge => $purge_resources,
  }

  # Default tags
  $tags = ['openstack', 'swift']

  # proxy settings
  $settings.each { |$setting, $value|
    swift_proxy_config { $setting:
      value => $value,
    }
  }

  cubbystack::functions::generic_service { 'swift-proxy':
    service_enable => $service_enable,
    package_ensure => $package_ensure,
    package_name   => $::cubbystack::params::swift_proxy_package_name,
    service_name   => $::cubbystack::params::swift_proxy_service_name,
    tags           => $::cubbystack::swift::tags,
  }
}
