class cubbystack::examples::roles::swift::account {

  $settings = hiera('swift_settings')

  rsync::server::module { 'account':
    path            => '/srv/node',
    lock_file       => "/var/lock/account.lock",
    uid             => 'swift',
    gid             => 'swift',
    max_connections => 25,
    read_only       => false,
  }

  $ring_server = hiera('swift_private_ip')
  rsync::get { '/etc/swift/account.ring.gz':
    source => "rsync://${ring_server}/swift_server/account.ring.gz",
  }

  anchor { 'cubbystack::examples::roles::swift::account': } ->

  class { '::cubbystack::swift::account':
    settings        => $settings['account'],
    purge_resources => $purge_resources,
  }
}
