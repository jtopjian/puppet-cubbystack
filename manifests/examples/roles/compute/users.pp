class cubbystack::examples::roles::compute::users {

  ::cubbystack::functions::create_system_user { 'nova':
    uid => hiera('nova_uid'),
    gid => hiera('nova_gid'),
  }

}
