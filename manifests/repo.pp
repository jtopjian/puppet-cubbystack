# Humbly based on the openstack module
class cubbystack::repo(
  $release = 'havana'
) {
  case $release {
    'havana', 'grizzly': {
      if $::osfamily == 'RedHat' {
        class {'cubbystack::repo::redhat': release => $release }
      } elsif $::operatingsystem == 'Ubuntu' {
        class {'cubbystack::repo::ubuntu': release => $release }
      }
    }
  }
}
