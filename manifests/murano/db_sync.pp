# == Class: cubbystack::murano::db_sync
#
# Schedules and performs the `murano-db-manage --config-file /etc/murano/murano.conf upgrade` command.
#
class cubbystack::murano::db_sync {

  # Order and notifications
  Package<| tag == 'cubbystack_murano' |>           ~> Exec['murano db sync']
  Cubbystack_config<| tag == 'cubbystack_murano' |> -> Exec['murano db sync']
  Exec['murano db sync']                            -> Service<| tag == 'cubbystack_murano' |>

  exec { 'murano db sync':
    path        => '/usr/bin',
    command     => 'murano-db-manage --config-file /etc/murano/murano.conf upgrade',
    refreshonly => true,
    logoutput   => 'on_failure',
  }

}
