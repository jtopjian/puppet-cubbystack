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
define cubbystack::functions::generic_service (
  $package_name   = false,
  $service_name   = false,
  $tags           = undef,
  $service_enable = true,
  $service_ensure = 'running',
  $package_ensure = present,
) {

  if $package_name {
    package { $title:
      ensure => $package_ensure,
      name   => $package_name,
      tag    => $tags,
    }
  }

  if $service_name {

    if $package_name {
      Package[$package_name] -> Service[$service_name]
      Package[$package_name] ~> Service[$service_name]
    }

    service { $title:
      ensure        => $service_ensure,
      name          => $service_name,
      enable        => $service_enable,
      tag           => $tags,
    }

  }

}
