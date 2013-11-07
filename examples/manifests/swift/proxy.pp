# swift configuration
class site::openstack::swift::proxy {

  anchor { 'site::openstack::swift::proxy': }

  Class {
    require => Anchor['site::openstack::swift::proxy'],
  }

  # sets up an rsync service that can be used to sync the ring DB
  rsync::server::module { 'swift_server':
    path            => '/etc/swift',
    lock_file       => '/var/lock/swift_server.lock',
    uid             => 'swift',
    gid             => 'swift',
    max_connections => 5,
    read_only       => true,
  }

  class { 'rsync::server':
    use_xinetd => true,
    address    => hiera('private_ip'),
    use_chroot => 'no'
  }

  # manage the rings
  Ring_object_device    <<| tag == $::location |>>
  Ring_container_device <<| tag == $::location |>>
  Ring_account_device   <<| tag == $::location |>>
  class { 'cubbystack::swift::rings':
    part_power     => hiera('swift_part_power'),
    replicas       => hiera('swift_replicas'),
    min_part_hours => 24,
  }


  class { 'memcached':
    listen_ip => '127.0.0.1',
  } ->

  class { '::cubbystack::swift::proxy':
    settings        => hiera('swift_proxy_settings'),
    purge_config => true,
  }


}
