class cubbystack::examples::roles::compute::libvirt (
  $package_ensure = latest,
  $service_enable = true
) {

  anchor { 'cubbystack::examples::roles::compute::libvirt': }

  class { '::cubbystack::nova::compute::libvirt':
    libvirt_type => hiera('libvirt_type'),
    require      => Anchor['cubbystack::examples::roles::compute::libvirt'],
  }

  ::cubbystack::functions::generic_service { 'libvirt-bin':
    package_name   => 'libvirt-bin',
    service_name   => 'libvirt-bin',
    package_ensure => latest,
    tags           => ['openstack', 'libvirt'],
  }

  # Enable migration support
  class { 'cubbystack::examples::roles::compute::migration_support':
    require => Package['libvirt-bin'],
  }

}
