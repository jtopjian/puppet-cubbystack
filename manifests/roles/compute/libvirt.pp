class cubbystack::roles::compute::libvirt (
  $package_ensure = latest,
  $service_enable = true
) {

  anchor { 'cubbystack::roles::compute::libvirt': }

  Class {
    require => Anchor['cubbystack::roles::compute::libvirt']
  }

  class { '::cubbystack::nova::compute::libvirt':
    libvirt_type => hiera('libvirt_type'),
  }

  ::cubbystack::functions::generic_service { 'libvirt-bin':
    package_name   => 'libvirt-bin',
    service_name   => 'libvirt-bin',
    package_ensure => latest,
    tags           => ['openstack', 'libvirt'],
  }

  # Enable migration support
  class { 'cubbystack::roles::compute::migration_support': }

}
