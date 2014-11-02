# == Defined Type: cubbystack::functions::create_openrc
#
# Creates an openrc OpenStack auth file
#
# === Parameters
#
# [*admin_password*]
#   The password of the admin
#   Required
#
# [*controller_node*]
#   The Keystone host
#   Defaults to 127.0.0.1
#
# [*admin_user*]
#   The name of the admin account
#   Defaults to admin
#
# [*admin_tenant*]
#   The name of the tenant the admin account belongs to
#   Defaults to admin
#
# [*region*]
#   The OpenStack region
#   Defaults to RegionOne
#
# [*protocol*]
#   Whether http or https
#
# [*owner*]
#   The system user owner of the file
#
# [*group*]
#   The system group owner of the file
#
define cubbystack::functions::create_openrc (
  $admin_password,
  $keystone_host  = '127.0.0.1',
  $admin_user     = 'admin',
  $admin_tenant   = 'admin',
  $region         = 'RegionOne',
  $protocol       = 'http',
  $owner          = 'root',
  $group          = 'root',
) {
  file { $name:
    owner   => $owner,
    group   => $group,
    mode    => '0640',
    content =>
"
export OS_TENANT_NAME=${admin_tenant}
export OS_USERNAME=${admin_user}
export OS_PASSWORD=\"${admin_password}\"
export OS_AUTH_URL=\"${protocol}://${keystone_host}:5000/v2.0/\"
export OS_AUTH_STRATEGY=keystone
export OS_REGION_NAME=${region}
"
  }
}
