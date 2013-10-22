# == Defined Type: cubbystack::functions::create_mysql_db
#
# Creates a MySQL Database.
#
# === Parameters
#
# [*password*]
#   The password of the user
#   Required
#
# [*user*]
#   The user to grant database access to
#   Required
#
# [*host*]
#   The host of the connecting user
#   Defaults to 127.0.0.1
#
# [*charset*]
#   The database charset
#   Defaults to latin1
#
# [*allowed_hosts*]
#   An array of hosts to allow additional access
#   Defaults to undef
#
# === Example Usage
#
# Please see the `manifests/examples` directory.
#
define cubbystack::functions::create_mysql_db (
  $password,
  $user,
  $host          = '127.0.0.1',
  $charset       = 'latin1',
  $collate       = 'latin1_swedish_ci',
  $allowed_hosts = undef,
) {

  mysql::db { $name:
    user     => $user,
    password => $password,
    host     => $host,
    charset  => $charset,
    collate  => $collate,
    tag      => ['openstack', 'mysql', $name],
  }

  if ($allowed_hosts) {
    $allowed_hosts.each { |$allowed_host|
      cubbystack::functions::mysql_host_access { "${name} ${allowed_host}:":
        user         => $user,
        password     => $password,
        database     => $name,
        allowed_host => $allowed_host,
        require      => Mysql::Db[$name],
      }
    }
  }
}
