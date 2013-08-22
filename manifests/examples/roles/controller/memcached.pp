class cubbystack::examples::roles::controller::memcached {

  anchor { 'cubbystack::examples::roles::controller::memcached': }

  $packages = ['python-memcache']
  package { $packages:
    ensure => latest,
  }

  class { '::memcached':
    listen_ip => '127.0.0.1',
    require   => Anchor['cubbystack::examples::roles::controller::memcached'],
  }

}
