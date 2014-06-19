class cubbystack::roles::compute::packages {

  $packages = ['radvd', 'python-netaddr', 'ebtables']
  package { $packages:
    ensure => latest,
  }

}
