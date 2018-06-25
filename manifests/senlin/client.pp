# == Class: cubbystack::senlin::client
#
# Installs python-senlinclient
#
# === Parameters
#
# [*version*]
#   The version of the senlin::client to install
#   Defaults to 7.0.1
#
class cubbystack::senlin::client (
  $version = 'master',
) {

  contain ::cubbystack::params

  ## Meta settings and globals
  $tags = ['cubbystack_openstack', 'cubbystack_senlin_client']

  # senlin-client package
  vcsrepo { '/srv/senlinclient':
    ensure   => present,
    provider => git,
    revision => $version,
    source   => 'https://github.com/openstack/python-senlinclient',
    notify   => Exec['install senlinclient'],
  }

  exec { 'install senlinclient':
    path        => ['/bin', '/usr/bin'],
    command     => 'python setup.py install',
    cwd         => '/srv/senlinclient',
    refreshonly => true,
    tag         => ['cubbystack_senlinclient_install'],
  }
}
