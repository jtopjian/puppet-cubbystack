class site::openstack::compute::libvirt (
  $package_ensure = latest,
  $service_enable = true
) {

  anchor { 'site::openstack::compute::libvirt': }

  Class {
    require => Anchor['site::openstack::compute::libvirt']
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
  class { 'site::openstack::compute::migration_support': }

}
