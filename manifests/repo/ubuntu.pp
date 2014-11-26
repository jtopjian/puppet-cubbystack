class cubbystack::repo::ubuntu (
  $release = 'juno',
  $repo    = 'updates'
) {

  case $::lsbdistcodename {
    'precise': {
      if $release != 'juno' {
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
    'trusty': {
      if $release == 'juno' {
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
}
