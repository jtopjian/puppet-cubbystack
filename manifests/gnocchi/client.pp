# == Class: cubbystack::gnocchi::client
#
# Installs python-gnocchiclient
#
# === Parameters
#
# [*package_ensure*]
#   The status of the gnocchi::client package
#   Defaults to present
#
class cubbystack::gnocchi::client (
  $package_ensure = present,
) {

  contain ::cubbystack::params

  ## Meta settings and globals
  $tags = ['cubbystack_openstack', 'cubbystack_gnocchi_client']

  # gnocchi-client package
  vcsrepo { '/srv/gnocchiclient':
    ensure   => present,
    provider => git,
    revision => '7.0.1',
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
