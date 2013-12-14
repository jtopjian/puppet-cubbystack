class site::openstack::controller::nova {

  $nova_settings = hiera_hash('nova_settings')

  anchor { 'site::openstack::controller::nova': }

  Class {
    require => Anchor['site::openstack::controller::nova'],
  }

  ## Nova

  # Configure Nova
  class { '::cubbystack::nova':
    settings => $nova_settings['conf'],
  }

  # Keystone authentication
  class { '::cubbystack::nova::keystone':
    settings => $nova_settings['paste'],
  }

  # a bunch of nova services that require no configuration
  class { [
    '::cubbystack::nova::api',
    '::cubbystack::nova::cert',
    '::cubbystack::nova::conductor',
    '::cubbystack::nova::consoleauth',
    '::cubbystack::nova::objectstore',
    '::cubbystack::nova::scheduler',
    '::cubbystack::nova::vncproxy',
   ]:
  }

  # Configure nova-network
  $neutron = hiera('keystone_network_endpoint', false)
  if ($neutron == false) {
    if (has_key($nova_settings['conf'], 'DEFAULT/multi_host')) {
      class { '::cubbystack::nova::network': }
    }
  }

  ## Generate an openrc file
  ::cubbystack::functions::create_openrc { '/root/openrc':
    keystone_host        => hiera('keystone_host'),
    admin_password       => hiera('keystone_admin_password'),
    keystone_admin_token => hiera('keystone_admin_token'),
    admin_tenant         => hiera('keystone_admin_tenant'),
    region               => hiera('openstack_region'),
  }

  class { '::cubbystack::nova::db_sync': }

}
