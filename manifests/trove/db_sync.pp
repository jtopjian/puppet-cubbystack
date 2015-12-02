# == Class: cubbystack::trove::db_sync
#
# Schedules and performs the `trove-manage db_sync` command.
#
class cubbystack::trove::db_sync {

  # Order the db_sync correctly
  Package<| tag == 'trove' |>           ~> Exec['trove-manage db_sync']
  Cubbystack_config<| tag == 'trove' |> -> Exec['trove-manage db_sync']
  Exec['trove-manage db_sync']          ~> Service<| tag == 'trove' |>

  # Configure the trove database
  exec { 'trove-manage db_sync':
    path        => '/usr/bin',
    refreshonly => true,
    logoutput   => 'on_failure',
  }

}
