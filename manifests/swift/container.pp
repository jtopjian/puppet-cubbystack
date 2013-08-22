# == Class: cubbystack::swift::container
#
# Configures the swift-container package and container-server.conf
#
# === Parameters
#
# [*settings*]
#   A hash of key => value settings to go in container-server.conf
#
# [*package_ensure*]
#   The status of the swift-container package
#   Defaults to latest
#
# [*service_enable*]
#   The status of the swift-container service.
#   Defaults to true
#
# [*purge_resources*]
#   Whether or not to purge all settings in container-server.conf
#   Defaults to true
#
# === Example Usage
#
# Please see the `manifests/examples` directory.
#
class cubbystack::swift::container (
  $settings,
  $purge_resources = true,
  $package_ensure  = latest,
  $service_enable  = true
) {

  include ::cubbystack::params
  include ::cubbystack::swift

  # Make sure swift is installed before configuration happens
  # Make sure swift is configured before the service starts
  Package<| tag == 'swift' |> -> Swift_container_config<||>
  Swift_container_config<||>  -> Service<| tag == 'swift' |>

  # Restart swift if the configuration changes
  Swift_container_config<||>  ~> Service<| tag == 'swift' |>

  # Purge all resources in container-server.conf?
  resources { 'swift_container_config':
    purge => $purge_resources,
  }

  # Default tags
  $tags = ['openstack', 'swift']

  # container settings
  $settings.each { |$setting, $value|
    swift_container_config { $setting:
      value => $value,
    }
  }

  # Package and service config
  if ($service_enable) {
    $service_ensure = 'running'
  } else {
    $service_ensure = 'stopped'
  }

  cubbystack::functions::generic_swift_service { 'container':
    service_enable => $service_enable,
    package_ensure => $package_ensure,
    tags           => $::cubbystack::swift::tags,
  }

  service { 'swift-container-auditor':
    name   => $::cubbystack::params::swift_container_auditor_service_name,
    enable => $service_enable,
    ensure => $service_ensure,
    tag    => $::cubbystack::swift::tags,
  }

  service { 'swift-container-updater':
    name   => $::cubbystack::params::swift_container_updater_service_name,
    enable => $service_enable,
    ensure => $service_ensure,
    tag    => $::cubbystack::swift::tags,
  }
}
