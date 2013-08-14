class cubbystack::examples::roles::controller::nova {

  $nova_settings = hiera('nova_controller_settings')

  anchor { 'cubbystack::controller::nova::begin': } ->

  ## Nova
  # Install / configure rabbitmq
  class { 'cubbystack::controller::rabbitmq':
    userid   => hiera('rabbit_user'),
    password => hiera('rabbit_password'),
  }

  # Configure Nova
  class { '::cubbystack::nova':
    settings => $nova_settings['conf'],
    require  => Anchor['cubbystack::controller::nova::begin'],
  }

  # Keystone authentication
  class { '::cubbystack::nova::keystone':
    settings => $nova_settings['paste'],
    require  => Anchor['cubbystack::controller::nova::begin'],
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
    require  => Anchor['cubbystack::controller::nova::begin'],
  }

  # Configure nova-network
  class { '::cubbystack::nova::network':
    private_interface => hiera('private_interface'),
    public_interface  => hiera('public_interface'),
    fixed_range       => hiera('fixed_range'),
    network_manager   => 'nova.network.manager.VlanManager',
    num_networks      => hiera('num_networks'),
    additional_config => {
      'vlan_start' => hiera('vlan_start'),
    },
    require  => Anchor['cubbystack::controller::nova::begin'],
  }

  ## Generate an openrc file
  ::cubbystack::functions::create_openrc { '/root/openrc':
    controller_node      => hiera('keystone_public_ip'),
    admin_password       => hiera('keystone_admin_password'),
    keystone_admin_token => hiera('keystone_admin_token'),
    admin_tenant         => hiera('keystone_admin_tenant'),
    region               => $::location,
  }

  class { '::cubbystack::nova::db_sync': }

}
