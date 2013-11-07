class site::openstack::controller::glance {

  $glance_settings = hiera_hash('glance_settings')

  anchor { 'site::openstack::controller::glance': }

  Class {
    require => Anchor['site::openstack::controller::glance'],
  }

  class { '::cubbystack::glance': }
  class { '::cubbystack::glance::api':
    settings        => $glance_settings['api'],
    purge_config => false,
  }

  class { '::cubbystack::glance::registry':
    settings        => $glance_settings['registry'],
    purge_config => false,
  }

  class { '::cubbystack::glance::cache':
    settings        => $glance_settings['cache'],
    purge_config => false,
  }

  class { '::cubbystack::glance::db_sync': }
}
