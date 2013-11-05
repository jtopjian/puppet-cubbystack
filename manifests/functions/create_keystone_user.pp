# == Defined Type: cubbystack::functions::create_keystone_user
#
# Creates a Keystone User.
#
# === Parameters
#
# [*password*]
#   The password of the user
#   Required
#
# [*tenant*]
#   The tenant the user belongs to
#   Required
#
# [*role*]
#   The default role of the user
#   Required
#
# [*email*]
#   Email address of the user
#   Required
#
# [*ensure*]
#   Status of the user's presence
#   Defaults to present
#
# [*enabled*]
#   Status of the user's account
#   Defaults to true
#
# === Example Usage
#
# Please see the `examples` directory.
#
define cubbystack::functions::create_keystone_user (
  $password,
  $tenant,
  $role,
  $email,
  $ensure    = 'present',
  $enabled   = 'true',
) {

  keystone_user { $name:
    ensure   => $ensure,
    enabled  => $enabled,
    password => $password,
    email    => $email,
    tenant   => $tenant,
    tag      => ['keystone', 'openstack', $name],
  }

  keystone_user_role { "${name}@${tenant}":
    ensure => present,
    roles  => $role,
    tag    => ['keystone', 'openstack', $name],
  }

}
