class cubbystack::examples::roles::swift::packages {

  $packages = ['python-mysqldb', 'xfsprogs', 'parted']
  package { $packages:
    ensure => latest,
  }

}
