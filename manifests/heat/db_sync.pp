# == Class: cubbystack::heat::db_sync
#
# Schedules and performs the `heat-manage db sync` command.
#
class cubbystack::heat::db_sync {

  # Order the db sync correctly
  Package<| tag == 'cubbystack_heat' |>           ~> Exec['heat db sync']
  Cubbystack_config<| tag == 'cubbystack_heat' |> -> Exec['heat db sync']
  Exec['heat db sync']                            ~> Service<| tag == 'cubbystack_heat' |>

  # Configure the heat database
  exec { 'heat db sync':
    path        => '/usr/bin',
    command     => 'heat-manage db_sync',
    refreshonly => true,
    logoutput   => 'on_failure',
  }

}
