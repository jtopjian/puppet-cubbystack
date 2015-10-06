class cubbystack::repo::ubuntu (
  $release = 'kilo',
  $repo    = 'updates'
) {

  case $::lsbdistcodename {
    'precise': {
      include apt::update

      apt::source { 'ubuntu-cloud-archive':
        location          => 'http://ubuntu-cloud.archive.canonical.com/ubuntu',
        release           => "${::lsbdistcodename}-${repo}/${release}",
        repos             => 'main',
        required_packages => 'ubuntu-cloud-keyring',
      }

      Exec['apt_update'] -> Package<||>

    }
    'trusty': {
      include apt::update

      apt::source { 'ubuntu-cloud-archive':
        location          => 'http://ubuntu-cloud.archive.canonical.com/ubuntu',
        release           => "${::lsbdistcodename}-${repo}/${release}",
        repos             => 'main',
        required_packages => 'ubuntu-cloud-keyring',
      }

      Exec['apt_update'] -> Package<||>

    }
  }
}
