class cubbystack::repo (
  $release = 'havana'
) {

  case $::lsbdistid {
    'Ubuntu': {
      package { 'ubuntu-cloud-keyring':
        ensure => latest,
      }

      file { '/etc/apt/sources.list.d/cloud.list':
        ensure  => present,
        content => template('cubbystack/cloud.list.erb'),
        require => Package['ubuntu-cloud-keyring'],
        notify  => Exec['apt-get update for openstack'],
      }

      exec { 'apt-get update for openstack':
        command     => '/usr/bin/apt-get update',
        refreshonly => true,
      }
    }
  }

}
