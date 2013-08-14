class cubbystack::examples::roles::controller::keystone {

  anchor { 'cubbystack::controller::keystone::begin': } ->

  class { '::cubbystack::keystone':
    settings        => hiera('keystone_settings'),
    admin_password  => hiera('keystone_admin_password'),
    purge_resources => false,
  } ->

  class { 'cubbystack::controller::keystone::endpoints': } ->
  class { 'cubbystack::controller::keystone::users': }

}
