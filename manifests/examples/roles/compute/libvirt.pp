class cubbystack::examples::roles::compute::libvirt (
  $package_ensure = latest,
  $service_enable = true
) {

  package { 'libvirt-bin':
    ensure => latest,
  }

  if ($service_enable) {
    $service_ensure = 'running'
  } else {
    $service_ensure = 'stopped'
  }

  service { 'libvirt-bin':
    enable  => $service_enable,
    ensure  => $service_ensure,
    require => Package['libvirt-bin'],
  }

  # Enable migration support
  class { 'cubbystack::examples::roles::compute::migration_support':
    require => Package['libvirt-bin'],
  }

}
