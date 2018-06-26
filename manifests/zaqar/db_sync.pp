# == Class: cubbystack::zaqar::db_sync
#
# Schedules and performs the `zaqar-manage db sync` command.
#
class cubbystack::zaqar::db_sync {

  # Order the db sync correctly
  Package<| tag == 'cubbystack_zaqar' |>           ~> Exec['zaqar db sync']
  Cubbystack_config<| tag == 'cubbystack_zaqar' |> -> Exec['zaqar db sync']
  Exec['zaqar db sync']                            ~> Service<| tag == 'cubbystack_zaqar' |>

  # Configure the zaqar database
  exec { 'zaqar db sync':
    path        => '/usr/bin',
    command     => 'zaqar-sql-db-manage upgrade heads',
    refreshonly => true,
    logoutput   => 'on_failure',
  }

}
