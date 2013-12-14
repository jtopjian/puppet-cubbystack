class site::openstack::compute::neutron {

  $neutron_settings = hiera_hash('neutron_settings')

  anchor { 'site::openstack::compute::neutron': }
  Class {
    require => Anchor['site::openstack::compute::neutron']
  }

  class { '::cubbystack::neutron':
    settings => $neutron['conf'],
  } ->

  class { '::cubbystack::neutron::plugins::ovs':
    settings => $neutron['ovs'],
  }

}
