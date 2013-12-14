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

  $neutron_settings = hiera('neutron_settings', false)
  if ($neutron_settings == false) {
    if (has_key($nova_settings['conf'], 'DEFAULT/multi_host')) {
      class { '::cubbystack::nova::keystone':
        settings => $nova_settings['paste'],
      }
      class { '::cubbystack::nova::network': }
    }
  }
}
