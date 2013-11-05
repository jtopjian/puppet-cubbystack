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
# [*purge_config*]
#   Whether or not to purge all settings in object-server.conf
#   Defaults to true
#
# === Example Usage
#
# Please see the `examples` directory.
#
class cubbystack::swift::object (
  $settings,
  $purge_config = true,
  $package_ensure  = latest,
  $service_enable  = true,
) {

  include ::cubbystack::params
  include ::cubbystack::swift

  # Make sure swift is installed before configuration happens
  # Make sure swift is configured before the service starts
  Package<| tag == 'swift' |> -> Swift_object_config<||>
  Swift_object_config<||>     -> Service<| tag == 'swift' |>

  # Restart swift if the configuration changes
  Swift_object_config<||> ~> Service<| tag == 'swift' |>

  # Purge all resources in object-server.conf?
  resources { 'cubbystack_config':
    purge => $purge_config,
    tag   => 'swift-object',
  }

  # Default tags
  $tags = ['openstack', 'swift']

  # object settings
  $settings.each { |$setting, $value|
    swift_object_container { $setting:
      value => $value,
    }
  }

  # Package and service config
  if ($service_enable) {
    $service_ensure = 'running'
  } else {
    $service_ensure = 'stopped'
  }

  cubbystack::functions::generic_swift_service { 'object':
    service_enable => $service_enable,
    package_ensure => $package_ensure,
    tags           => $::cubbystack::swift::tags,
  }

  service { 'swift-object-auditor':
    name   => $::cubbystack::params::swift_object_auditor_service_name,
    enable => $service_enable,
    ensure => $service_ensure,
    tag    => $::cubbystack::swift::tags,
  }

  service { 'swift-object-updater':
    name   => $::cubbystack::params::swift_object_updater_service_name,
    enable => $service_enable,
    ensure => $service_ensure,
    tag    => $::cubbystack::swift::tags,
  }
}
