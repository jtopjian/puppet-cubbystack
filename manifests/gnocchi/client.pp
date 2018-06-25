# == Class: cubbystack::gnocchi::client
#
# Installs python-gnocchiclient
#
# === Parameters
#
# [*version*]
#   The version of the gnocchi::client to install
#   Defaults to master
#
class cubbystack::gnocchi::client (
  $version = 'master',
) {

  contain ::cubbystack::params

  ## Meta settings and globals
  $tags = ['cubbystack_openstack', 'cubbystack_gnocchi_client']

  # gnocchi-client package
  vcsrepo { '/srv/gnocchiclient':
    ensure   => present,
    provider => git,
    revision => $version,
    source   => 'https://github.com/gnocchixyz/python-gnocchiclient',
  }

  python::requirements { '/srv/gnocchiclient/requirements.txt':
    require => Vcsrepo['/srv/gnocchiclient'],
    notify  => Exec['install gnocchiclient'],
  }

  exec { 'install gnocchiclient':
    path        => ['/bin', '/usr/bin'],
    command     => 'python setup.py install',
    cwd         => '/srv/gnocchiclient',
    refreshonly => true,
    tag         => ['cubbystack_gnocchiclient_install'],
  }
}
