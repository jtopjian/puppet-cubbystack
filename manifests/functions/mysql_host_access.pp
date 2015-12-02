# == Defined Type: cubbystack::functions::mysql_host_access
#
# Shortcut to provide access to a database from additional hosts
# Exact copy from original openstack modules
#
# === Parameters
#
# [*user*]
#   The user to grant access to
#   Required
#
# [*password*]
#   The password of the user
#   Required
#
# [*allowed_hosts*]
#   The host of the connecting user.
#   Required
#
# [*database*]
#   The database to allow the user access
#   Required
#
define cubbystack::functions::mysql_host_access (
  $user,
  $password,
  $allowed_host,
  $database       = '*',
  $privileges     = ['ALL'],
) {
  mysql_user { "${user}@${allowed_host}":
    password_hash => mysql_password($password),
  }
  mysql_grant { "${user}@${allowed_host}/${database}.*":
    privileges => $privileges,
    table      => "${database}.*",
    user       => "${user}@${allowed_host}",
    require    => Mysql_user["${user}@${allowed_host}"]
  }

}
