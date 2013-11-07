class site::openstack::controller::rabbitmq {

  $user     = hiera('rabbit_user', 'guest')
  $password = hiera('rabbit_password', 'guest')
  $vhost    = hiera('rabbit_virtual_host', '/')

  anchor { 'site::openstack::controller::rabbitmq': }

  Class {
    require => Anchor['site::openstack::controller::rabbitmq']
  }

  class { '::rabbitmq::server':
    delete_guest_user => $delete_guest_user,
  }

  if $user == 'guest' {
    $delete_guest_user = false
  } else {
    $delete_guest_user = true
    rabbitmq_user { $user:
      admin    => true,
      password => $password,
      require  => Class['::rabbitmq::server'],
    }
    rabbitmq_user_permissions { "${user}@${vhost}":
      configure_permission => '.*',
      write_permission     => '.*',
      read_permission      => '.*',
    }
  }

  rabbitmq_vhost { $vhost:
    require => Class['::rabbitmq::server'],
  }
}
