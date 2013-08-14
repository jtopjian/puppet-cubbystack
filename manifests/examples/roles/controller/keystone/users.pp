class cubbystack::examples::roles::controller::keystone::users {

  Service['keystone'] -> ::Cubbystack::Functions::Create_keystone_user<||>

  ::cubbystack::functions::create_keystone_user { 'nova':
    password => hiera('nova_keystone_password'),
    tenant   => 'services',
    role     => 'admin',
    email    => 'nova@localhost',
  }

  ::cubbystack::functions::create_keystone_user { 'glance':
    password => hiera('glance_keystone_password'),
    tenant   => 'services',
    role     => 'admin',
    email    => 'glance@localhost',
  }

  ::cubbystack::functions::create_keystone_user { 'keystone':
    password => hiera('keystone_admin_password'),
    tenant   => 'services',
    role     => 'admin',
    email    => 'keystone@localhost',
  }

  ::cubbystack::functions::create_keystone_user { 'cinder':
    password => hiera('cinder_keystone_password'),
    tenant   => 'services',
    role     => 'admin',
    email    => 'cinder@localhost',
  }

  ::cubbystack::functions::create_keystone_user { 'swift':
    password => hiera('swift_keystone_password'),
    tenant   => 'services',
    role     => 'admin',
    email    => 'swift@localhost',
  }

}
