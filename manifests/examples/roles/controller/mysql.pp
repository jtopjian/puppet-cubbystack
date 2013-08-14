class cubbystack::examples::roles::controller::mysql {

  $mysql_allowed_hosts   = hiera('mysql_allowed_hosts')

  # This removes default users and guest access
  class { 'mysql::server::account_security': }

  anchor { 'cubbystack::examples::roles::controller::mysql::begin': } ->

  ## MySQL
  # Install and configure MySQL Server
  class { 'mysql::server':
    config_hash => {
      'root_password' => hiera('mysql_root_password'),
      'bind_address'  => hiera('mysql_bind_address'),
    },
    enabled     => $enabled,
  } ->

  # Create the Keystone db
  ::cubbystack::functions::create_mysql_db { 'keystone':
    user          => hiera('keystone_mysql_user'),
    password      => hiera('keystone_mysql_password'),
    allowed_hosts => hiera('mysql_allowed_hosts'),
  } ->

  # Create the Glance db
  ::cubbystack::functions::create_mysql_db { 'glance':
    user          => hiera('glance_mysql_user'),
    password      => hiera('glance_mysql_password'),
    allowed_hosts => hiera('mysql_allowed_hosts'),
  } ->

  # Create the Nova db
  ::cubbystack::functions::create_mysql_db { 'nova':
    user          => hiera('nova_mysql_user'),
    password      => hiera('nova_mysql_password'),
    allowed_hosts => hiera('mysql_allowed_hosts'),
  } ->

  # Create the Cinder db
  ::cubbystack::functions::create_mysql_db { 'cinder':
    user          => hiera('cinder_mysql_user'),
    password      => hiera('cinder_mysql_password'),
    allowed_hosts => hiera('mysql_allowed_hosts'),
  }

}
