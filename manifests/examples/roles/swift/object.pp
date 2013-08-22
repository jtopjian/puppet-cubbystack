class cubbystack::examples::roles::swift::object {

  $settings = hiera('swift_settings')

  rsync::server::module { 'object':
    path            => '/srv/node',
    lock_file       => "/var/lock/object.lock",
    uid             => 'swift',
    gid             => 'swift',
    max_connections => 25,
    read_only       => false,
  }

  $ring_server = hiera('swift_private_ip')
  rsync::get { '/etc/swift/object.ring.gz':
    source => "rsync://${ring_server}/swift_server/object.ring.gz",
  }

  anchor { 'cubbystack::examples::roles::swift::object': } ->

  class { '::cubbystack::swift::object':
    settings        => $settings['object'],
    purge_resources => $purge_resources,
  }
}