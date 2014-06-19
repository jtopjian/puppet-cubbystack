class cubbystack::roles::controller::cinder {

  anchor { 'cubbystack::roles::controller::cinder': }

  Class {
    require => Anchor['cubbystack::roles::controller::cinder']
  }

  class { '::cubbystack::cinder':
    settings => hiera_hash('cinder_settings'),
  }

  class { [
      '::cubbystack::cinder::api',
      '::cubbystack::cinder::scheduler',
      '::cubbystack::cinder::volume',
    ]:
  }

  class { '::cubbystack::cinder::db_sync': }

}
