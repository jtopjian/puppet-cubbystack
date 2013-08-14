class cubbystack::examples::roles::compute::node {

  $nova_settings = hiera('nova_compute_settings')

  anchor { 'cubbystack::compute::node::begin': } ->

  ## Nova
  class { '::cubbystack::nova':
    settings => $nova_settings['conf'],
  }

  # Install / configure nova-compute
  class { '::cubbystack::nova::compute':
    require => Anchor['cubbystack::compute::node::begin'],
  }

  # Configure compute type
  class { '::cubbystack::nova::compute::libvirt':
    libvirt_type => 'qemu',
    require      => Anchor['cubbystack::compute::node::begin'],
  }

}
