# == Class: cubbystack::swift::container_sync
#
# Configures the swift container-sync service
#
# === Parameters
#
# [*settings*]
#   A hash of key => value settings to go in container-sync-realms.conf
#
# [*manage_service*]
#   Whether to manage the service or not.
#   The config file is applied to all swift servers, but the service does
#   not run on the swift proxy.
#
# [*service_enable*]
#   The status of the swift-container service.
#   Defaults to true
#
# [*config_file*]
#   The path to container-server.conf
#   Defaults to /etc/swift/container-sync-realms.conf
#
class cubbystack::swift::container_sync (
  $realm_settings,
  $client_settings    = undef,
  $manage_service     = false,
  $package_ensure     = present,
  $service_enable     = true,
  $realm_config_file  = '/etc/swift/container-sync-realms.conf',
  $client_config_file = '/etc/swift/container-sync-client.conf',
) {

  contain ::cubbystack::params

  ## Meta settings and globals
  $tags = ['cubbystack_openstack', 'cubbystack_swift', 'swift-container', 'swift-container-sync']

  # Restart container-sync if the configuration changes
  Cubbystack_config<| tag == 'swift-container' |>  ~> Service<| tag == 'swift-container' |>
  Cubbystack_config<| tag == 'swift-container-sync' |>  ~> Service<| tag == 'swift-container-sync' |>

  # container settings
  $realm_settings.each |$setting, $value| {
    cubbystack_config { "${realm_config_file}: ${setting}":
      value => $value,
      tag   => $tags,
    }
  }

  $client_settings.each |$setting, $value| {
    cubbystack_config { "${client_config_file}: ${setting}":
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

  # Manage the container-sync service
  if ($manage_service) {
    service { 'swift-container-sync':
      name   => $::cubbystack::params::swift_container_sync_service_name,
      enable => $service_enable,
      ensure => $service_ensure,
      tag    => $tags,
    }
  }

}
