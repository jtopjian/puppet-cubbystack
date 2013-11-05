class site::openstack::compute::users {

  ::cubbystack::functions::create_system_user { 'nova':
    uid => hiera('nova_uid'),
    gid => hiera('nova_gid'),
  }

  ::cubbystack::functions::create_system_user { 'cinder':
    uid => hiera('cinder_uid'),
    gid => hiera('cinder_gid'),
  }
}
