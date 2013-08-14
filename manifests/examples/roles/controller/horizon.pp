class cubbystack::examples::roles::controller::horizon {

  # Configuration
  $public_hostname = hiera('cloud_public_hostname')

  File {
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode   => '0640',
  }

  anchor { 'cubbystack::examples::roles::controller::horizon::begin': } ->

  class { 'cubbystack::horizon': } ->

  class { 'apache': } ->

  file { "/etc/ssl/certs/${cloud_public_hostname}.crt":
    source => "puppet:///modules/admin/ssl/${cloud_public_hostname}.crt",
  } ->

  file { "/etc/ssl/private/${cloud_public_hostname}.key":
    source => "puppet:///modules/admin/ssl/${cloud_public_hostname}.key",
  } ->

  file { '/etc/ssl/certs/intermediate.pem':
    source => 'puppet:///modules/admin/ssl/intermediate.pem',
  } ->

  apache::vhost { "${cloud_public_hostname}-nossl":
    servername      => $cloud_public_hostname,
    port            => 80,
    docroot         => '/var/www',
    redirect_status => 'permanent',
    redirect_dest   => "https://${cloud_public_hostname}/",
  } ->

  apache::vhost { "${cloud_public_hostname}-ssl":
    docroot  => '/var/www',
    port     => 443,
    ssl      => true,
    ssl_cert => "/etc/ssl/certs/${cloud_public_hostname}.crt",
    ssl_key  => "/etc/ssl/private/${cloud_public_hostname}.key",
    ssl_ca   => '/etc/ssl/certs/intermediate.pem',
  } ->

  file_line { 'horizon root url':
    path  => '/etc/apache2/conf.d/openstack-dashboard',
    line  => 'WSGIScriptAlias / /usr/share/openstack-dashboard/openstack_dashboard/wsgi/django.wsgi',
    match => 'WSGIScriptAlias ',
  }

}
