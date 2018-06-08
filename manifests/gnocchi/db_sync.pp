# == Class: cubbystack::gnocchi::db_sync
#
# Schedules and performs the `gnocchi-upgrade` command.
#
class cubbystack::gnocchi::db_sync {

  # Order the db sync correctly
  Exec<| tag == 'cubbystack_gnocchi_install' |>      ~> Exec['gnocchi db sync']
  Cubbystack_config<| tag == 'cubbystack_gnocchi' |> -> Exec['gnocchi db sync']
  Exec['gnocchi db sync']                            ~> Service<| tag == 'cubbystack_gnocchi' |>

  # Configure the gnocchi database
  exec { 'gnocchi db sync':
    path        => ['/bin', '/usr/bin', '/usr/local/bin'],
    command     => 'gnocchi-upgrade',
    refreshonly => true,
    logoutput   => 'on_failure',
  }

}
