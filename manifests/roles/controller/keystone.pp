class cubbystack::roles::controller::keystone {

  anchor { 'cubbystack::roles::controller::keystone': }

  Class {
    require => Anchor['cubbystack::roles::controller::keystone']
  }

  class { '::cubbystack::keystone':
    settings        => hiera_hash('keystone_settings'),
    admin_password  => hiera('keystone_admin_password'),
    purge_resources => false,
  }

  class { 'cubbystack::roles::controller::keystone::endpoints': }
  class { 'cubbystack::roles::controller::keystone::users': }

}
