class site::openstack::swift::users {

  ::cubbystack::functions::create_system_user { 'swift':
    uid => hiera('swift_uid'),
    gid => hiera('swift_gid'),
  }

}
