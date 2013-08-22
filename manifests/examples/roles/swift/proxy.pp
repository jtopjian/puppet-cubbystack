# == Class: cubbystack::examples::roles::swift::proxy
#
# Applies a swift proxy server role to a server
#
# == Example Usage:
#
# node /proxy/ {
#   class { 'cubbystack::examples::roles::swift::users': } ->
#   class { 'cubbystack::examples::roles::swift::packages': } ->
#   class { 'cubbystack::examples::roles::swift::proxy_packages': } ->
#   class { 'cubbystack::swift':
#     swift_hash_path_suffix => hiera('swift_hash_path_suffix'),
#   } ->
#   class { 'cubbystack::examples::roles::swift::proxy': }
# }
#
class cubbystack::examples::roles::swift::proxy {

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

  anchor { 'cubbystack::examples::roles::swift::proxy': } ->

  class { 'memcached':
    listen_ip => '127.0.0.1',
  } ->

  class { '::cubbystack::swift::proxy':
    settings        => hiera('swift_proxy_settings'),
    purge_resources => true,
  }

}
