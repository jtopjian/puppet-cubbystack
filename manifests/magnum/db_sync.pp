# == Class: cubbystack::magnum::db_sync
#
# Schedules and performs the `magnum-manage db sync` command.
#
class cubbystack::magnum::db_sync {

  include ::cubbystack::magnum

  # Order the db sync correctly
  Package<| tag == 'cubbystack_magnum' |>           ~> Exec['magnum db sync']
  Cubbystack_config<| tag == 'cubbystack_magnum' |> -> Exec['magnum db sync']
  Exec['magnum db sync']                            ~> Service<| tag == 'cubbystack_magnum' |>

  # Configure the magnum database
  exec { 'magnum db sync':
    path        => '/usr/bin',
    command     => 'magnum-db-manage upgrade',
    refreshonly => true,
    logoutput   => 'on_failure',
    tag         => $::cubbystack::magnum::tags,
  }

}
