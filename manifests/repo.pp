# Humbly based on the openstack module
class cubbystack::repo (
  $release = 'icehouse'
) {

  anchor { 'cubbystack::repo::start': }
  anchor { 'cubbystack::repo::end': }

  #Class {
  #  require => Anchor['cubbystack::repo::start'],
  #  before  => Anchor['cubbystack::repo::end']
  #}

  $hiera_release = hiera('cubbystack::repo::release')
  #notify { "Actual: $release vs Expected: $hiera_release": }
  if $::osfamily == 'RedHat' {
    class { 'cubbystack::repo::redhat': release => $release }
  } elsif $::operatingsystem == 'Ubuntu' {
    class { 'cubbystack::repo::ubuntu': release => $release }
  }

}
