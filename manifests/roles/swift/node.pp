# swift configuration
class cubbystack::roles::swift::node (
  $swift_zone,
) {

  $swift_disks = hiera('swift_disks')

  anchor { 'cubbystack::roles::swift::node': }

  Class {
    require => Anchor['cubbystack::roles::swift::node']
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

  cubbystack::roles::swift::create_device { $swift_disks:
    swift_zone => $swift_zone,
    require    => File['/srv/node'],
  }

  class { 'cubbystack::roles::swift::account': }
  class { 'cubbystack::roles::swift::container': }
  class { 'cubbystack::roles::swift::object': }

}
