class cubbystack::examples::roles::compute::node {

  $nova_settings = hiera('nova_compute_settings')

  anchor { 'cubbystack::examples::roles::compute::node::begin': } ->

  ## Nova
  class { '::cubbystack::nova':
    settings => $nova_settings['conf'],
  }

  # Install / configure nova-compute
  class { '::cubbystack::nova::compute':
    require => Anchor['cubbystack::examples::roles::compute::node::begin'],
  }

  # Configure compute type
  class { '::cubbystack::nova::compute::libvirt':
    libvirt_type => 'qemu',
    require      => Anchor['cubbystack::examples::roles::compute::node::begin'],
  }

}
