# == Class: cubbystack::trove::db_sync
#
# Schedules and performs the `trove db sync` command.
#
class cubbystack::trove::db_sync {

  # Order the db_sync correctly
  Package<| tag == 'cubbystack_trove' |>           ~> Exec['trove db sync']
  Cubbystack_config<| tag == 'cubbystack_trove' |> -> Exec['trove db sync']
  Exec['trove db sync']                            ~> Service<| tag == 'cubbystack_trove' |>

  # Configure the trove database
  exec { 'trove db sync':
    path        => '/usr/bin',
    command     => 'trove-manage db_sync',
    refreshonly => true,
    logoutput   => 'on_failure',
  }

}
