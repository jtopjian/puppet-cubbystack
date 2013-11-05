class site::openstack::controller::memcached {

  anchor { 'site::openstack::controller::memcached': }

  Class {
    require => Anchor['site::openstack::controller::memcached']
  }

  $packages = ['python-memcache']
  package { $packages:
    ensure => latest,
  }

  class { '::memcached':
    listen_ip => '127.0.0.1',
  }

}
