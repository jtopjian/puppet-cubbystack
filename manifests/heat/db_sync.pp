# == Class: cubbystack::heat::db_sync
#
# Schedules and performs the `heat-manage db sync` command.
#
class cubbystack::heat::db_sync {

  # Order the db sync correctly
  Package<| tag == 'heat' |>           ~> Exec['heat-manage db_sync']
  Cubbystack_config<| tag == 'heat' |> -> Exec['heat-manage db_sync']
  Exec['heat-manage db_sync']          ~> Service<| tag == 'heat' |>

  # Configure the heat database
  exec { 'heat-manage db_sync':
    path        => '/usr/bin',
    refreshonly => true,
    logoutput   => 'on_failure',
  }

}
