# == Class: cubbystack::nova::db_sync
#
# Schedules and performs the `nova db sync` command.
#
class cubbystack::nova::db_sync {

  # Order the db sync correctly
  Package<| tag == 'cubbystack_nova' |>           ~> Exec['nova db sync']
  Cubbystack_config<| tag == 'cubbystack_nova' |> -> Exec['nova db sync']
  Exec['nova db sync']                            ~> Service<| tag == 'cubbystack_nova' |>

  # Configure the nova database
  exec { 'nova db sync':
    path        => '/usr/bin',
    command     => 'nova-manage db sync',
    refreshonly => true,
    logoutput   => 'on_failure',
  }

}
