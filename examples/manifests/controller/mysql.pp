class site::openstack::controller::mysql {

  $trusted_networks_mysql = hiera_array('trusted_networks_mysql')

  anchor { 'site::openstack::controller::mysql': }

  Class {
    require => Anchor['site::openstack::controller::mysql']
  }

  # Create the Keystone db
  ::cubbystack::functions::create_mysql_db { 'keystone':
    user          => hiera('keystone_mysql_user'),
    password      => hiera('keystone_mysql_password'),
    allowed_hosts => $trusted_networks_mysql,
  }

  # Create the Glance db
  ::cubbystack::functions::create_mysql_db { 'glance':
    user          => hiera('glance_mysql_user'),
    password      => hiera('glance_mysql_password'),
    allowed_hosts => $trusted_networks_mysql,
  }

  # Create the Nova db
  ::cubbystack::functions::create_mysql_db { 'nova':
    user          => hiera('nova_mysql_user'),
    password      => hiera('nova_mysql_password'),
    allowed_hosts => $trusted_networks_mysql,
  }

  # Create the Cinder db
  ::cubbystack::functions::create_mysql_db { 'cinder':
    user          => hiera('cinder_mysql_user'),
    password      => hiera('cinder_mysql_password'),
    allowed_hosts => $trusted_networks_mysql,
  }

}
