class site::openstack::users {

  $openstack_users = hiera_hash('openstack_users')
  $openstack_users.each { |$user, $info|
    ::cubbystack::functions::create_system_user { $user:
      uid => $info['uid'],
      gid => $info['gid'],
    }
  }

}
