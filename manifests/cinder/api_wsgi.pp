class cubbystack::cinder::api_wsgi {

  contain cubbystack::params

  $apache_service_name = $::cubbystack::params::apache_service_name
  exec { 'cinder-api-apache':
    path        => ['/bin', '/usr/sbin'],
    command     => "service ${apache_service_name} restart",
    refreshonly => true,
    logoutput   => 'on_failure',
    tag         => 'cubbystack_cinder_api_apache',
  }

}
