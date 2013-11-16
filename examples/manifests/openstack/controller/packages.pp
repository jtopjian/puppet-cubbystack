class site::openstack::controller::packages {

  # Packages required by OpenStack
  $openstack_packages = ['python-mysqldb', 'websockify', 'python-netaddr', 'radvd', 'ebtables']
  package { $openstack_packages:
    ensure => latest,
  }

}
