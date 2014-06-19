define cubbystack::roles::swift::create_device (
  $swift_zone
) {

  $ip     = hiera('private_ip')
  $device = "/dev/${name}"

  exec { "mkfs-${name}":
    command => "mkfs.xfs -f -i size=1024 ${device}",
    path    => ['/sbin', '/usr/sbin',],
    unless  => "xfs_admin -l ${device}",
  }

  file { "/srv/node/${name}":
    ensure  => directory,
    owner   => 'swift',
    group   => 'swift',
    require => Exec["mkfs-${name}"],
  }

  mount { "/srv/node/${name}":
    ensure  => present,
    device  => $device,
    fstype  => 'xfs',
    options => 'noatime,nodiratime,nobarrier,logbufs=8',
    require => File["/srv/node/${name}"],
  }

  @@ring_object_device { "${ip}:6000/${name}":
    zone   => $swift_zone,
    weight => 1,
    tag    => $::location,
  }

  @@ring_container_device { "${ip}:6001/${name}":
    zone   => $swift_zone,
    weight => 1,
    tag    => $::location,
  }

  @@ring_account_device { "${ip}:6002/${name}":
    zone   => $swift_zone,
    weight => 1,
    tag    => $::location,
  }
}
