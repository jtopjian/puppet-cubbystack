class site::openstack::controller (
  $horizon_config_file = 'puppet:///modules/cubbystack/horizon/local_settings.py'
) {

  anchor { 'site::openstack::controller': }

  Class {
    require => [Anchor['site::openstack::controller'], Class['mysql::server']]
  }

  class { '::cubbystack::repo': } ->
  class { 'site::openstack::controller::users': } ->
  class { 'site::openstack::controller::packages': } ->
  class { 'site::openstack::controller::memcached': } ->
  class { 'site::openstack::controller::mysql': } ->
  class { 'site::openstack::controller::rabbitmq': } ->
  class { 'site::openstack::controller::keystone': } ->
  class { 'site::openstack::controller::glance': } ->
  class { 'site::openstack::controller::cinder': } ->
  class { 'site::openstack::controller::nova': } ->
  class { 'site::openstack::controller::neutron': } ->
  class { 'site::openstack::controller::horizon':
    config_file => $horizon_config_file,
  }

}
