class cubbystack::repo::ubuntu (
  $release = 'juno',
  $repo    = 'updates'
) {

  include apt::update

  if ! ($::lsbdistcodename == "trusty" and $release == "icehouse") and ! ($::lsbdistcodename == "xenial" and $release == "mitaka") {
    apt::source { 'ubuntu-cloud-archive':
      location          => 'http://ubuntu-cloud.archive.canonical.com/ubuntu',
      release           => "${::lsbdistcodename}-${repo}/${release}",
      repos             => 'main',
      required_packages => 'ubuntu-cloud-keyring',
    }
  }

}
