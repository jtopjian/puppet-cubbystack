# == Class: cubbystack::swift::expirer
#
# Configures the swift-object-expirer package and object-expirer.conf
#
# === Parameters
#
# [*settings*]
#   A hash of key => value settings to go in object-expirer.conf
#
# [*package_ensure*]
#   The status of the swift-object-expirer package
#   Defaults to present
#
# [*service_enable*]
#   The status of the swift-object-expirer service.
#   Defaults to true
#
# [*config_file*]
#   The path to the object-expirer.conf file
#   Defaults to /etc/swift/object-expirer.conf
#
# === Example Usage
#
# Please see the `examples` directory.
#
class cubbystack::swift::expirer (
  $settings,
  $package_ensure = present,
  $service_enable = true,
  $config_file    = '/etc/swift/object-expirer.conf',
) {

  contain ::cubbystack::params

  ## Meta settings and globals
  $tags = ['cubbystack_openstack', 'cubbystack_swift', 'swift-object-expirer']

  # Restart swift if the configuration changes
  Cubbystack_config<| tag == 'swift-object-expirer' |> ~> Service<| tag == 'swift-object-expirer' |>

  # object settings
  $settings.each |$setting, $value| {
    cubbystack_config { "${config_file}: ${setting}":
      value => $value,
      tag   => $tags,
    }
  }

  # Package and service config
  if ($service_enable) {
    $service_ensure = 'running'
  } else {
    $service_ensure = 'stopped'
  }

  # Install the swift-proxy package and manage its service
  cubbystack::functions::generic_service { 'swift-object-expirer':
    service_enable => $service_enable,
    package_ensure => $package_ensure,
    package_name   => $::cubbystack::params::swift_expirer_package_name,
    service_name   => $::cubbystack::params::swift_expirer_service_name,
    tags           => $tags,
  }
}
