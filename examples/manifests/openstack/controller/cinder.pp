class site::openstack::controller::cinder {

  anchor { 'site::openstack::controller::cinder': }

  Class {
    require => Anchor['site::openstack::controller::cinder']
  }

  $cinder_settings = hiera_hash('cinder_settings')
  class { '::cubbystack::cinder':
    settings => $cinder_settings['conf'],
  }

  # Keystone authentication
  class { '::cubbystack::cinder::keystone':
    settings => $cinder_settings['paste'],
  }

  class { [
      '::cubbystack::cinder::api',
      '::cubbystack::cinder::scheduler',
      '::cubbystack::cinder::volume',
    ]:
  }

  class { '::cubbystack::cinder::db_sync': }

}
