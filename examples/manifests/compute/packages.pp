class site::openstack::compute::packages {

  $packages = ['radvd', 'python-netaddr', 'ebtables']
  package { $packages:
    ensure => latest,
  }

}
