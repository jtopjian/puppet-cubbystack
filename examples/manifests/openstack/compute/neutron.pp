class site::openstack::compute::neutron {

  $neutron_settings = hiera_hash('neutron_settings')

  anchor { 'site::openstack::compute::neutron': }
  Class {
    require => Anchor['site::openstack::compute::neutron']
  }

  class { '::cubbystack::neutron':
    settings => $neutron_settings['conf'],
  }

  class { '::cubbystack::neutron::plugins::ovs':
    settings => $neutron_settings['ovs'],
  }

}
