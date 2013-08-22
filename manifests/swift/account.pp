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
# [*purge_resources*]
#   Whether or not to purge all settings in account-server.conf
#   Defaults to true
#
# === Example Usage
#
# Please see the `manifests/examples` directory.
#
class cubbystack::swift::account (
  $settings,
  $purge_resources = true,
  $package_ensure  = latest,
  $service_enable  = true
) {

  include ::cubbystack::params
  include ::cubbystack::swift

  # Make sure swift is installed before configuration happens
  # Make sure swift is configured before the service starts
  Package<| tag == 'swift' |> -> Swift_account_config<||>
  Swift_account_config<||>    -> Service<| tag == 'swift' |>

  # Restart swift if the configuration changes
  Swift_account_config<||>    ~> Service<| tag == 'swift' |>

  # Purge all resources in account-server.conf?
  resources { 'swift_account_config':
    purge => $purge_resources,
  }

  # Default tags
  $tags = ['openstack', 'swift']

  # account settings
  $settings.each { |$setting, $value|
    swift_account_config { $setting:
      value => $value,
    }
  }

  # Package and service config
  if ($service_enable) {
    $service_ensure = 'running'
  } else {
    $service_ensure = 'stopped'
  }

  cubbystack::functions::generic_swift_service { 'account':
    service_enable => $service_enable,
    package_ensure => $package_ensure,
    tags           => $::cubbystack::swift::tags,
  }

  service { 'swift-account-auditor':
    name   => $::cubbystack::params::swift_account_auditor_service_name,
    enable => $service_enable,
    ensure => $service_ensure,
    tag    => $::cubbystack::swift::tags,
  }
}
