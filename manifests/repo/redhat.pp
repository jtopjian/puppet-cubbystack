# Humbly taken from the stackforge openstack module
class cubbystack::repo::redhat (
  $release = 'havana'
) {

  $release_cap = capitalize($release)

  if $::osfamily == 'RedHat' {
    case $::operatingsystem {
      centos, redhat, scientific, slc: { $dist = 'epel' }
      fedora: { $dist = 'fedora' }
      default: { $dist = 'epel' }
    }
    # $lsbmajdistrelease is only available with redhat-lsb installed
    $osver = regsubst($::operatingsystemrelease, '(\d+)\..*', '\1')

    yumrepo { 'rdo-release':
      baseurl  => "http://repos.fedorapeople.org/repos/openstack/openstack-${release}/${dist}-${osver}/",
      descr    => "OpenStack ${release_cap} Repository",
      enabled  => 1,
      gpgcheck => 1,
      gpgkey   => "file:///etc/pki/rpm-gpg/RPM-GPG-KEY-RDO-${release_cap}",
      priority => 98,
      notify   => Exec['yum_refresh'],
    }
    file { "/etc/pki/rpm-gpg/RPM-GPG-KEY-RDO-${release_cap}":
      source => "puppet:///modules/cubbystack/repo/RPM-GPG-KEY-RDO-${release_cap}",
      owner  => root,
      group  => root,
      mode   => '0644',
      before => Yumrepo['rdo-release'],
    }
    Yumrepo['rdo-release'] -> Package<||>
  }

  exec { 'yum_refresh':
    command     => '/usr/bin/yum clean all',
    refreshonly => true,
  }

  Exec['yum_refresh'] -> Package<||>
}
