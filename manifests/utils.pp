class cubbystack::utils (
  $package_ensure = present
) {

  include cubbystack::params

  if $::cubbystack::params::openstack_utils {
    package { $::cubbystack::params::openstack_utils:
      ensure => $package_ensure,
    }
  }

}
