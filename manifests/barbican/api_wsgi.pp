class cubbystack::barbican::api_wsgi {

  include ::cubbystack::params

  $apache_service_name = $::cubbystack::params::apache_service_name
  exec { 'barbican-api-apache':
    path        => ['/bin', '/usr/sbin'],
    command     => "service ${apache_service_name} restart",
    refreshonly => true,
    logoutput   => 'on_failure',
    tag         => 'cubbystack_barbican_api_apache',
  }

}
