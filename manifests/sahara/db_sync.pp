# == Class: cubbystack::sahara::db_sync
#
# Schedules and performs the `sahara-db-manage --config-file /etc/sahara/sahara.conf upgrade` command.
#
class cubbystack::sahara::db_sync {

  # Order and notifications
  Package<| tag == 'cubbystack_sahara' |>           ~> Exec['sahara db sync']
  Cubbystack_config<| tag == 'cubbystack_sahara' |> -> Exec['sahara db sync']
  Exec['sahara db sync']                            -> Service<| tag == 'cubbystack_sahara' |>

  exec { 'sahara db sync':
    path        => '/usr/bin',
    command     => 'sahara-db-manage --config-file /etc/sahara/sahara.conf upgrade',
    refreshonly => true,
    logoutput   => 'on_failure',
  }

}
