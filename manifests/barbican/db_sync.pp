# == Class: cubbystack::barbican::db_sync
#
# Schedules and performs the `barbican-manage db sync` command.
#
class cubbystack::barbican::db_sync {

  # Order the db sync correctly
  Package<| tag == 'cubbystack_barbican' |>           ~> Exec['barbican db sync']
  Cubbystack_config<| tag == 'cubbystack_barbican' |> -> Exec['barbican db sync']
  Exec['barbican db sync']                            ~> Service<| tag == 'cubbystack_barbican' |>

  # Configure the barbican database
  exec { 'barbican db sync':
    path        => '/usr/bin',
    command     => 'barbican-manage db upgrade',
    refreshonly => true,
    logoutput   => 'on_failure',
  }

}
