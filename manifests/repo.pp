# Humbly based on the openstack module
class cubbystack::repo (
  $release = 'juno'
) {

  anchor { 'cubbystack::repo::start': }
  anchor { 'cubbystack::repo::end': }

  Class {
    require => Anchor['cubbystack::repo::start'],
    before  => Anchor['cubbystack::repo::end']
  }

  if $::osfamily == 'RedHat' {
    class { 'cubbystack::repo::redhat': release => $release }
  } elsif $::operatingsystem == 'Ubuntu' {
    class { 'cubbystack::repo::ubuntu': release => $release }
  }

}
