class cubbystack::roles::controller (
  $horizon_config_file = 'puppet:///modules/cubbystack/horizon/local_settings.py'
) {

  anchor { 'cubbystack::roles::controller': }

  Class {
    require => Anchor['cubbystack::roles::controller']
  }

  class { 'cubbystack::roles::controller::users': } ->
  class { 'cubbystack::roles::controller::packages': } ->
  class { 'cubbystack::roles::controller::memcached': } ->
  class { 'cubbystack::roles::controller::mysql': } ->
  class { 'cubbystack::roles::controller::rabbitmq': } ->
  class { 'cubbystack::roles::controller::keystone': } ->
  class { 'cubbystack::roles::controller::glance': } ->
  class { 'cubbystack::roles::controller::cinder': } ->
  class { 'cubbystack::roles::controller::nova': } ->
  class { 'cubbystack::roles::controller::horizon':
    config_file => $horizon_config_file,
  }

}
