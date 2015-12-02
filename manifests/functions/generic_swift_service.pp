# == Defined Type: cubbystack::functions::generic_swift_service
#
# Shortcut to install a package and control a service provided by the package
#
# === Parameters
#
# [*name*]
#   The swift service type such as account, container, object
#   Required
#
# [*tags*]
#   Any tags to add to the package and service
#   Defaults to undef
#
# [*service_enable*]
#   The status of the service
#   Defaults to true
#
# [*package_ensure*]
#   The status of the package
#   Defaults to present
#
define cubbystack::functions::generic_swift_service (
  $tags           = undef,
  $service_enable = true,
  $package_ensure = present,
) {

  $type = $name

  if $service_enable {
    $service_ensure = 'running'
  } else {
    $service_ensure = 'stopped'
  }

  $package_name = getvar("::cubbystack::params::swift_${type}_package_name")
  if $package_name {
    package { "swift-${type}":
      ensure => $package_ensure,
      name   => $package_name,
      tag    => $tags,
    }
  }

  $service_name = getvar("::cubbystack::params::swift_${type}_service_name")
  if $service_name {
    service { "swift-${type}":
      ensure  => $service_ensure,
      enable  => $service_enable,
      name    => $service_name,
      tag     => $tags,
      require => Package["swift-${type}"],
    }
  }

  $replicator_name = getvar("::cubbystack::params::swift_${type}_replicator_service_name")
  if $replicator_name {
    service { "swift-${type}-replicator":
      ensure  => $service_ensure,
      enable  => $service_enable,
      name    => $replicator_name,
      tag     => $tags,
      require => Package["swift-${type}"],
    }
  }

}
