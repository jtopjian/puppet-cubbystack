# == Class: cubbystack::swift::object
#
# Configures the swift-object package and object-server.conf
#
# === Parameters
#
# [*settings*]
#   A hash of key => value settings to go in object-server.conf
#
# [*package_ensure*]
#   The status of the swift-object package
#   Defaults to latest
#
# [*service_enable*]
#   The status of the swift-object service.
#   Defaults to true
#
# [*config_file*]
#   The path to the object-server.conf file
#   Defaults to /etc/swift/object-server.conf
#
# === Example Usage
#
# Please see the `examples` directory.
#
class cubbystack::swift::object (
  $settings,
  $package_ensure = latest,
  $service_enable = true,
  $config_file    = '/etc/swift/object-server.conf',
) {

  include ::cubbystack::params

  ## Meta settings and globals
  $tags = ['openstack', 'swift', 'swift-object']

  # Restart swift if the configuration changes
  Cubbystack_config<| tag == 'swift-object' |> ~> Service<| tag == 'swift-object' |>

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

  # Install the swift-object package and manage its service
  cubbystack::functions::generic_swift_service { 'object':
    service_enable => $service_enable,
    package_ensure => $package_ensure,
    tags           => $tags,
  }

  # Manage the supplemental auditor service
  service { 'swift-object-auditor':
    name   => $::cubbystack::params::swift_object_auditor_service_name,
    enable => $service_enable,
    ensure => $service_ensure,
    tag    => $tags,
  }

  # Manage the supplemental updater service
  service { 'swift-object-updater':
    name   => $::cubbystack::params::swift_object_updater_service_name,
    enable => $service_enable,
    ensure => $service_ensure,
    tag    => $tags,
  }
}
