class site::openstack::controller::cinder::nfs {
  $nfs_server        = hiera('nfs_server')
  $nfs_volume_export = hiera('nfs_volume_export')

  file { '/etc/cinder/shares.conf':
    ensure  => present,
    owner   => 'cinder',
    group   => 'cinder',
    mode    => '0640',
    content => "${nfs_server}:${nfs_volume_export}\n",
    require => Class['::cubbystack::cinder'],
  }
}
