class cubbystack::repo::ubuntu (
  $release = 'kilo',
  $repo    = 'updates'
) {

  contain apt::update
  if ! ($::lsbdistcodename == 'xenial' and $release == 'mitaka') {
    apt::source { 'ubuntu-cloud-archive':
      location          => 'http://ubuntu-cloud.archive.canonical.com/ubuntu',
      release           => "${::lsbdistcodename}-${repo}/${release}",
      repos             => 'main',
      required_packages => 'ubuntu-cloud-keyring',
    }
  }

}
