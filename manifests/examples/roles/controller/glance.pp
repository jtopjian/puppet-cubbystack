class cubbystack::examples::roles::controller::glance {

  $glance_settings = hiera('glance_settings')

  anchor { 'cubbystack::examples::roles::controller::glance::begin': } ->

  class { '::cubbystack::glance': }
  class { '::cubbystack::glance::api':
    settings        => $glance_settings['api'],
    purge_resources => false,
  }

  class { '::cubbystack::glance::registry':
    settings        => $glance_settings['registry'],
    purge_resources => false,
  }

  class { '::cubbystack::glance::cache':
    settings        => $glance_settings['cache'],
    purge_resources => false,
  }

  class { '::cubbystack::glance::db_sync': }
}
