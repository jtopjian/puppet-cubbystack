class cubbystack::roles::controller::memcached {

  anchor { 'cubbystack::roles::controller::memcached': }

  $packages = ['python-memcache']
  package { $packages:
    ensure => latest,
  }

  class { '::memcached':
    listen_ip => '127.0.0.1',
    require   => Anchor['cubbystack::roles::controller::memcached'],
  }

}
