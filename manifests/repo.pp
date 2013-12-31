class cubbystack::repo (
  $release = 'havana'
) {

  case $::lsbdistid {
    'Ubuntu': {
      package { 'ubuntu-cloud-keyring':
        ensure => latest,
      }

      case $::lsbdistcodename {
        'precise': {
          apt::source {
            location         => 'http://ubuntu-cloud.archive.canonical.com/ubuntu',
            release          => "precise-updates/${release}",
            repos            => 'main',
            require_packages => 'ubuntu-cloud-keyring'
          }
        }
      }

    }
  }

}
