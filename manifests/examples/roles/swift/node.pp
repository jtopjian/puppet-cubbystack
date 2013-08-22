# == Class: cubbystack::examples::roles::swift::node
#
# Applies a swift storage node role to a server
#
# === Parameters
#
# [*swift_zone*]
#  The zone number of the node. Integer
#  Required.
#
# == Example Usage:
#
# node /s01/, /s02/ {
#   class { 'cubbystack::examples::roles::swift::users': } ->
#   class { 'cubbystack::examples::roles::swift::packages': } ->
#   class { 'cubbystack::swift':
#     swift_hash_path_suffix => hiera('swift_hash_path_suffix'),
#   } ->
#   class { 'cubbystack::examples::roles::swift::node':
#     swift_zone => 1,
#   }
# }
#
class cubbystack::examples::roles::swift::node (
  $swift_zone,
) {

  $swift_disks = hiera('swift_disks')

  class { 'rsync::server':
    use_xinetd => true,
    address    => hiera('private_ip'),
    use_chroot => 'no'
  }

  file { '/srv/node':
    ensure => directory,
    owner  => 'swift',
    group  => 'swift',
    mode   => '0640',
  }

  cubbystack::examples::roles::swift::create_device { $swift_disks:
    swift_zone => $swift_zone,
    require    => File['/srv/node'],
  }

  anchor { 'cubbystack::examples::roles::swift::node': } ->
  class { 'cubbystack::examples::roles::swift::account': } ->
  class { 'cubbystack::examples::roles::swift::container': } ->
  class { 'cubbystack::examples::roles::swift::object': }

}
