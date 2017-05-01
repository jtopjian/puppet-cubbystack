# == Class: cubbystack::nova::api_db_sync
#
# Schedules and performs the `nova-manage api_db sync` command.
#
class cubbystack::nova::api_db_sync {

  # Order the db sync correctly
  Package<| tag == 'nova' |>           ~> Exec['nova-manage api_db sync']
  Cubbystack_config<| tag == 'nova' |> -> Exec['nova-manage api_db sync']
  Exec['nova-manage api_db sync']          ~> Service<| tag == 'nova' |>

  # Configure the nova database
  exec { 'nova-manage api_db sync':
    path        => '/usr/bin',
    refreshonly => true,
    logoutput   => 'on_failure',
  }

}
