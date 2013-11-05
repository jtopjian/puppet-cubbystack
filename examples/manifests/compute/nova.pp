class site::openstack::compute::nova {

  $nova_settings = hiera_hash('nova_settings')

  anchor { 'site::openstack::compute::nova': }

  Class {
    require => Anchor['site::openstack::compute::nova']
  }

  ## Nova
  class { '::cubbystack::nova':
    settings => $nova_settings['conf'],
  }

  # Install / configure nova-compute
  class { '::cubbystack::nova::compute': }

  $multi_host = $nova_settings['conf']['DEFAULT/multi_host']
  if ($multi_host) {
    # Install / configure nova-compute
    class { '::cubbystack::nova::api': }

    # Keystone authentication
    class { '::cubbystack::nova::keystone':
      settings => $nova_settings['paste'],
    }

    class { '::cubbystack::nova::network':
      create_networks   => false,
      fixed_range       => $nova_settings['conf']['DEFAULT/fixed_range'],
      private_interface => $nova_settings['conf']['DEFAULT/flat_interface'],
    }
  }
}
