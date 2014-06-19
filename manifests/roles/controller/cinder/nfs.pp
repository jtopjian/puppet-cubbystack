class cubbystack::roles::controller::cinder::nfs {
  $nfs_server            = hiera('nfs_server')
  $nfs_volume_mountpoint = hiera('nfs_volume_mountpoint')

  file { '/etc/cinder/shares.conf':
    ensure  => present,
    owner   => 'cinder',
    group   => 'cinder',
    mode    => '0640',
    content => "${nfs_server}:${nfs_volume_mountpoint}\n",
    require => Class['::cubbystack::cinder'],
  }
}
