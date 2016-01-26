# == Class: cubbystack::nova::db_sync
#
# Schedules and performs the `nova-manage db sync` command.
#
class cubbystack::nova::db_sync {

  # Order the db sync correctly
  Package<| tag == 'nova' |>           ~> Exec['nova-manage db sync']
  Cubbystack_config<| tag == 'nova' |> -> Exec['nova-manage db sync']
  Exec['nova-manage db sync']          ~> Service<| tag == 'nova' |>

  # Configure the nova database
  exec { 'nova-manage db sync':
    path        => '/usr/bin',
    refreshonly => true,
    logoutput   => 'on_failure',
  }

}
