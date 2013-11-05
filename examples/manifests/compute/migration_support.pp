class site::openstack::compute::migration_support {

  case $::lsbdistid {
    'Ubuntu': {

      # Ubuntu-specific, not Debian, due to upstart
      File_line {
        path   => '/etc/libvirt/libvirtd.conf',
        notify => Service['libvirt-bin'],
      }

      file_line { '/etc/libvirt/libvirtd.conf listen_tls':
        line  => 'listen_tls = 0',
        match => 'listen_tls =',
      }

      file_line { '/etc/libvirt/libvirtd.conf listen_tcp':
        line  => 'listen_tcp = 1',
        match => 'listen_tcp =',
      }

      file_line { '/etc/libvirt/libvirtd.conf auth_tcp':
        line   => 'auth_tcp = "none"',
        match  => 'auth_tcp =',
      }

      file_line { '/etc/init/libvirt-bin.conf libvirtd opts':
        path  => '/etc/init/libvirt-bin.conf',
        line  => 'env libvirtd_opts="-d -l"',
        match => 'env libvirtd_opts=',
      }

      file_line { '/etc/default/libvirt-bin libvirtd opts':
        path  => '/etc/default/libvirt-bin',
        line  => 'libvirtd_opts="-d -l"',
        match => 'libvirtd_opts=',
      }

    }
  }
}
