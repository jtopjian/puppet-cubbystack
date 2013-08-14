class cubbystack::examples::roles::controller::users {

  ::cubbystack::functions::create_system_user { 'nova':
    uid => hiera('nova_uid'),
    gid => hiera('nova_gid'),
  }

  ::cubbystack::functions::create_system_user { 'keystone':
    uid => hiera('keystone_uid'),
    gid => hiera('keystone_gid'),
  }

  ::cubbystack::functions::create_system_user { 'glance':
    uid => hiera('glance_uid'),
    gid => hiera('glance_gid'),
  }

  ::cubbystack::functions::create_system_user { 'cinder':
    uid => hiera('cinder_uid'),
    gid => hiera('cinder_gid'),
  }
}
