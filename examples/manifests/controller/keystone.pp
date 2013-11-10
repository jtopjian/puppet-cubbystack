class site::openstack::controller::keystone {

  anchor { 'site::openstack::controller::keystone': }

  Class {
    require => Anchor['site::openstack::controller::keystone']
  }

  class { '::cubbystack::keystone':
    settings        => hiera_hash('keystone_settings'),
    admin_password  => hiera('keystone_admin_password'),
  }

  class { 'site::openstack::controller::keystone::endpoints': }
  class { 'site::openstack::controller::keystone::users': }

}
