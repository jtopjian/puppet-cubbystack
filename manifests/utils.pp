class cubbystack::utils (
  $package_ensure = present
) {

  contain cubbystack::params

  if $::cubbystack::params::openstack_utils {
    package { $::cubbystack::params::openstack_utils:
      ensure => $package_ensure,
    }
  }

}
