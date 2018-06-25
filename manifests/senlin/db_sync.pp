# == Class: cubbystack::senlin::db_sync
#
# Schedules and performs the `senlin db sync` command.
#
class cubbystack::senlin::db_sync {

  # Order the db sync correctly
  Exec<| tag == 'cubbystack_senlin_install' |>      ~> Exec['senlin db sync']
  Cubbystack_config<| tag == 'cubbystack_senlin' |> -> Exec['senlin db sync']
  Exec['senlin db sync']                            ~> Service<| tag == 'cubbystack_senlin' |>

  # Configure the senlin database
  exec { 'senlin db sync':
    path        => ['/bin', '/usr/bin', '/usr/local/bin'],
    command     => '/srv/senlin/tools/senlin-db-recreate',
    refreshonly => true,
    logoutput   => 'on_failure',
  }

}
