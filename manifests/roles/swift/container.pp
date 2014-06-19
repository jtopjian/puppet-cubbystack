class cubbystack::roles::swift::container {

  $settings = hiera('swift_settings')

  anchor { 'cubbystack::roles::swift::container': }

  Class {
    require => Anchor['cubbystack::roles::swift::container'],
  }

  rsync::server::module { 'container':
    path            => '/srv/node',
    lock_file       => "/var/lock/container.lock",
    uid             => 'swift',
    gid             => 'swift',
    max_connections => 25,
    read_only       => false,
  }

  $ring_server = hiera('swift_private_ip')
  rsync::get { '/etc/swift/container.ring.gz':
    source => "rsync://${ring_server}/swift_server/container.ring.gz",
  }

  class { '::cubbystack::swift::container':
    settings        => $settings['container'],
    purge_resources => $purge_resources,
  }
}
