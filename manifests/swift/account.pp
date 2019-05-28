# == Class: cubbystack::swift::account
#
# Configures the swift-account package and account-server.conf
#
# === Parameters
#
# [*settings*]
#   A hash of key => value settings to go in account-server.conf
#
# [*package_ensure*]
#   The status of the swift-account package
#   Defaults to latest
#
# [*service_enable*]
#   The status of the swift-account service.
#   Defaults to true
#
# [*config_file*]
#   The path to account-server.conf
#   Defaults to /etc/swift/account-server.conf
#
class cubbystack::swift::account (
  $settings,
  $package_ensure = latest,
  $service_enable = true,
  $config_file    = '/etc/swift/account-server.conf',
) {

  include ::cubbystack::params

  ## Meta settings and globals
  $tags = ['cubbystack_openstack', 'cubbystack_swift', 'swift-account']

  # Restart account-server if the configuration changes
  Cubbystack_config<| tag == 'swift-account' |> ~> Service<| tag == 'swift-account' |>
  Cubbystack_config<| tag == 'swift-account' |> ~> Exec['cubbystack restart swift']

  # account settings
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

  # Install the account server and manage its service
  cubbystack::functions::generic_swift_service { 'account':
    service_enable => $service_enable,
    package_ensure => $package_ensure,
    tags           => $tags,
  }

  # Manage the supplemental swift-account-auditor service
  service { 'swift-account-auditor':
    ensure => $service_ensure,
    enable => $service_enable,
    name   => $::cubbystack::params::swift_account_auditor_service_name,
    tag    => $tags,
  }
}
