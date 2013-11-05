class site::openstack::swift::packages {

  $packages = ['python-mysqldb', 'xfsprogs', 'parted']
  package { $packages:
    ensure => latest,
  }

}
