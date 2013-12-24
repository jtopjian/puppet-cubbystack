class site::openstack::controller::mysql {

  # Don't forget to add
  # include ::mysql::server
  # somewhere

  $trusted_networks_mysql = hiera_array('trusted_networks_mysql')

  anchor { 'site::openstack::controller::mysql': }

  Class {
    require => Anchor['site::openstack::controller::mysql']
  }

  # Create the Keystone db
  ::cubbystack::functions::create_mysql_db { 'keystone':
    user          => 'keystone',
    password      => hiera('keystone_mysql_password'),
    allowed_hosts => $trusted_networks_mysql,
  }

  # Create the Glance db
  ::cubbystack::functions::create_mysql_db { 'glance':
    user          => 'glance',
    password      => hiera('glance_mysql_password'),
    allowed_hosts => $trusted_networks_mysql,
  }

  # Create the Nova db
  ::cubbystack::functions::create_mysql_db { 'nova':
    user          => 'nova',
    password      => hiera('nova_mysql_password'),
    allowed_hosts => $trusted_networks_mysql,
  }

  # Create the Cinder db
  ::cubbystack::functions::create_mysql_db { 'cinder':
    user          => 'cinder',
    password      => hiera('cinder_mysql_password'),
    allowed_hosts => $trusted_networks_mysql,
  }

  # Create the Neutron db
  ::cubbystack::functions::create_mysql_db { 'neutron':
    user          => 'neutron',
    password      => hiera('neutron_mysql_password'),
    allowed_hosts => $trusted_networks_mysql,
  }

}
