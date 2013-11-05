# == Defined Type: cubbystack::functions::generic_service
#
# Shortcut to install a package and control a service provided by the package
#
# === Parameters
#
# [*package_name*]
#   The package to install
#   Required
#
# [*service_name*]
#   The service that the package provides
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
# === Example Usage
#
# Please see the `examples` directory.
#
define cubbystack::functions::generic_service (
  $package_name   = false,
  $service_name   = false,
  $tags           = undef,
  $service_enable = true,
  $package_ensure = present,
) {

  if ($service_enable) {
    $service_ensure = 'running'
  } else {
    $service_ensure = 'stopped'
  }

  if ($package_name) {
    package { $title:
      name   => $package_name,
      ensure => $package_ensure,
      tag    => $tags,
    }
  }

  if ($service_name) {

    if ($package_name) {
      Package[$package_name] -> Service[$service_name]
      Package[$package_name] ~> Service[$service_name]
    }

    service { $title:
      name    => $service_name,
      ensure  => $service_ensure,
      enable  => $enable,
      tag     => $tags,
    }

  }

}
