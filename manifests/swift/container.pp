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
#   Defaults to present
#
# [*service_enable*]
#   The status of the swift-container service.
#   Defaults to true
#
# [*config_file*]
#   The path to container-server.conf
#   Defaults to /etc/swift/container-server.conf
#
class cubbystack::swift::container (
  $settings,
  $package_ensure = present,
  $service_enable = true,
  $config_file    = '/etc/swift/container-server.conf',
) {

  include ::cubbystack::params

  ## Meta settings and globals
  $tags = ['cubbystack_openstack', 'cubbystack_swift', 'swift-container']

  # Restart container-server if the configuration changes
  Cubbystack_config<| tag == 'swift-container' |>  ~> Service<| tag == 'swift-container' |>

  # container settings
  $settings.each |$setting, $value| {
    cubbystack_config { "${config_file}: ${setting}":
      value => $value,
      tag   => $tags,
    }
  }

  # Package and service config
  if $service_enable {
    $service_ensure = 'running'
  } else {
    $service_ensure = 'stopped'
  }

  # Install the container server package and manage its service
  cubbystack::functions::generic_swift_service { 'container':
    service_enable => $service_enable,
    package_ensure => $package_ensure,
    tags           => $tags,
  }

  # Manage the supplemental auditor service
  service { 'swift-container-auditor':
    ensure => $service_ensure,
    enable => $service_enable,
    name   => $::cubbystack::params::swift_container_auditor_service_name,
    tag    => $tags,
  }

  # Manage the supplemental updater service
  service { 'swift-container-updater':
    ensure => $service_ensure,
    enable => $service_enable,
    name   => $::cubbystack::params::swift_container_updater_service_name,
    tag    => $tags,
  }
}
