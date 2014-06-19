class cubbystack::roles::controller::keystone::endpoints {

  # Endpoint changes cause Keystone to restart
  Cubbystack::Functions::Create_keystone_endpoint<||> -> Service['keystone']
  Cubbystack::Functions::Create_keystone_endpoint<||> ~> Service['keystone']

  # Setup the Keystone Identity Endpoint
  $region = hiera('openstack_region')
  ::cubbystack::functions::create_keystone_endpoint { "${region}/identity":
    public_url   => hiera('keystone_identity_endpoint'),
    admin_url    => hiera('keystone_identity_admin_endpoint'),
    internal_url => hiera('keystone_identity_endpoint'),
    service_name => 'OpenStack Identity Service',
    tag          => $region,
  }

  # Configure Glance endpoint in Keystone
  ::cubbystack::functions::create_keystone_endpoint { "${region}/image":
    public_url   => hiera('keystone_image_endpoint'),
    admin_url    => hiera('keystone_image_endpoint'),
    internal_url => hiera('keystone_image_endpoint'),
    service_name => 'OpenStack Image Service',
    tag          => $region,
  }

  # Configure Nova endpoint in Keystone
  ::cubbystack::functions::create_keystone_endpoint { "${region}/compute":
    public_url   => hiera('keystone_compute_endpoint'),
    admin_url    => hiera('keystone_compute_endpoint'),
    internal_url => hiera('keystone_compute_endpoint'),
    service_name => 'OpenStack Compute Service',
    tag          => $region,
  }

  # Configure EC2 endpoint in Keystone
  ::cubbystack::functions::create_keystone_endpoint { "${region}/ec2":
    public_url   => hiera('keystone_ec2_endpoint'),
    admin_url    => hiera('keystone_ec2_endpoint'),
    internal_url => hiera('keystone_ec2_endpoint'),
    service_name => 'OpenStack EC2 Service',
    tag          => $region,
  }

  # Configure Cinder endpoint in Keystone
  ::cubbystack::functions::create_keystone_endpoint { "${region}/volume":
    public_url   => hiera('keystone_volume_endpoint'),
    admin_url    => hiera('keystone_volume_endpoint'),
    internal_url => hiera('keystone_volume_endpoint'),
    service_name => 'OpenStack Volume Service',
    tag          => $region,
  }

}
