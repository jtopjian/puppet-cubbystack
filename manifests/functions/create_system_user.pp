# == Defined Type: cubbystack::functions::create_system_user
#
# Shortcut to create a system user.
#
# === Parameters
#
# [*uid*]
#   The uid of the user
#   Required
#
# [*gid*]
#   The gid of the user
#   Required
#
# [*ensure*]
#   Status of the user
#   Defaults to present
#
# === Example Usage
#
# Please see the `manifests/examples` directory.
define cubbystack::functions::create_system_user (
  $uid,
  $gid,
  $ensure = present
) {

  group { $name:
    ensure => $ensure,
    system => true,
    gid    => $gid,
    tag    => ['openstack', $name],
  }

  user { $name:
    ensure  => $ensure,
    system  => true,
    uid     => $uid,
    gid     => $gid,
    home    => "/var/lib/${name}",
    tag     => ['openstack', $name],
    require => Group[$name],
  }

}
