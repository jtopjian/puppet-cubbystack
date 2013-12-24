class site::openstack::controller::neutron {

  anchor { 'site::openstack::controller::neutron': }

  Class {
    require => Anchor['site::openstack::controller::neutron']
  }

  $neutron_settings = hiera_hash('neutron_settings')
  class { '::cubbystack::neutron':
    settings => $neutron_settings['conf'],
  }

  # Keystone authentication
  class { '::cubbystack::neutron::keystone':
    settings => $neutron_settings['paste'],
  }

  class { '::cubbystack::neutron::dhcp':
    settings => $neutron_settings['dhcp'],
  }

  class { '::cubbystack::neutron::l3':
    settings => $neutron_settings['l3'],
  }

  class { '::cubbystack::neutron::metadata':
    settings => $neutron_settings['metadata'],
  }

  class { '::cubbystack::neutron::plugins::ovs':
    settings => $neutron_settings['ovs'],
  }

}
