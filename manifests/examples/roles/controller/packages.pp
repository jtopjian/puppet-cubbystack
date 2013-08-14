class cubbystack::examples::roles::controller::packages {

  # Packages required by OpenStack
  $openstack_packages = ['python-mysqldb', 'python-memcache', 'memcached', 'websockify', 'node-less']
  package { $openstack_packages:
    ensure => latest,
  }

}
