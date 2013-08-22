class cubbystack::examples::roles::swift::proxy_packages {

  $packages = ['swift-plugin-s3', 'python-keystone', 'python-keystoneclient']

  package { $packages:
    ensure => latest,
  }

}
