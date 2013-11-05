# swift configuration
class site::openstack::swift::node (
  $swift_zone,
) {

  $swift_disks = hiera('swift_disks')

  anchor { 'site::openstack::swift::node': }

  Class {
    require => Anchor['site::openstack::swift::node']
  }

  class { 'rsync::server':
    use_xinetd => true,
    address    => hiera('private_ip'),
    use_chroot => 'no'
  }

  file { '/srv/node':
    ensure => directory,
    owner  => 'swift',
    group  => 'swift',
    mode   => '0644',
  }

  site::openstack::swift::create_device { $swift_disks:
    swift_zone => $swift_zone,
    require    => File['/srv/node'],
  }

  class { 'site::openstack::swift::account': }
  class { 'site::openstack::swift::container': }
  class { 'site::openstack::swift::object': }

}
