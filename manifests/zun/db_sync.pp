# == Class: cubbystack::zun::db_sync
#
# Schedules and performs the `zun db sync` command.
#
class cubbystack::zun::db_sync {

  # Order the db sync correctly
  Exec<| tag == 'cubbystack_zun_install' |>      ~> Exec['zun db sync']
  Cubbystack_config<| tag == 'cubbystack_zun' |> -> Exec['zun db sync']
  Exec['zun db sync']                            ~> Service<| tag == 'cubbystack_zun' |>

  # Configure the zun database
  exec { 'zun db sync':
    path        => ['/bin', '/usr/bin', '/usr/local/bin'],
    command     => 'zun-db-manage upgrade',
    refreshonly => true,
    logoutput   => 'on_failure',
  }

}
