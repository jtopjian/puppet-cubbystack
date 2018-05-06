class cubbystack::repo::ubuntu (
  $release = 'queens',
  $repo    = 'updates'
) {

  if ! ($::lsbdistcodename == "trusty" and $release == "icehouse") and ! ($::lsbdistcodename == "xenial" and $release == "mitaka") {
    package { 'ubuntu-cloud-keyring':
      ensure => latest,
    }

    apt::source { 'ubuntu-cloud-archive':
      location => 'http://ubuntu-cloud.archive.canonical.com/ubuntu',
      release  => "${::lsbdistcodename}-${repo}/${release}",
      repos    => 'main',
      notify   => Exec['apt-get update cloud archive'],
      require  => Package['ubuntu-cloud-keyring'],
    }

    exec { 'apt-get update cloud archive':
      command     => '/usr/bin/apt-get update',
      refreshonly => true,
    }
  }

}
