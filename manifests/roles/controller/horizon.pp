class cubbystack::roles::controller::horizon (
  $config_file = 'puppet:///modules/cubbystack/horizon/local_settings.py',
) {

  anchor { 'cubbystack::roles::controller::horizon': }

  Class {
    require => Anchor['cubbystack::roles::controller::horizon']
  }

  # Packages required by Horizon
  $horizon_packages = ['python-django', 'python-compressor', 'python-appconf', 'python-cloudfiles', 'python-tz', 'node-less']
  package { $horizon_packages:
    ensure => latest,
  }

  class { '::cubbystack::horizon':
    config_file => $config_file,
  }

  file_line { 'horizon root url':
    path    => '/etc/apache2/conf.d/openstack-dashboard.conf',
    line    => 'WSGIScriptAlias / /usr/share/openstack-dashboard/openstack_dashboard/wsgi/django.wsgi',
    match   => 'WSGIScriptAlias ',
    require => Class['cubbystack::horizon'],
  }

}
