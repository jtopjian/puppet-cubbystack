# == Class: cubbystack::nova::placement_db_sync
#
# Schedules and performs the `placement-manage db sync` command.
#
class cubbystack::nova::placement_db_sync {

  # Order the db sync correctly
  Package<| tag == 'cubbystack_nova' |>           ~> Exec['placement db sync']
  Cubbystack_config<| tag == 'cubbystack_nova' |> -> Exec['placement db sync']
  Exec['placement db sync']                        ~> Service<| tag == 'cubbystack_nova' |>

  # Configure the nova api database
  exec { 'placement db sync':
    path        => '/usr/bin',
    command     => 'placement-manage db sync',
    refreshonly => true,
    logoutput   => 'on_failure',
  }

}
