class cubbystack::examples::roles::controller::cinder {

  anchor { 'cubbystack::examples::roles::controller::cinder::begin': } ->

  class { '::cubbystack::cinder':
    settings => hiera('cinder_settings'),
  }

  class { [
      '::cubbystack::cinder::api',
      '::cubbystack::cinder::scheduler',
      '::cubbystack::cinder::volume',
    ]:
      require => Anchor['cubbystack::examples::roles::controller::cinder::begin'],
  }

  class { '::cubbystack::cinder::db_sync': }

}
