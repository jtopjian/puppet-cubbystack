# == Class: cubbystack::glance::db_sync
#
# Schedules and performs the `glance-manage db_sync` command.
#
class cubbystack::glance::db_sync {

  # Order and notifications
  Package<| tag == 'cubbystack_glance' |>           ~> Exec['glance db sync']
  Cubbystack_config<| tag == 'cubbystack_glance' |> -> Exec['glance db sync']
  Exec['glance db sync']                            -> Service<| tag == 'cubbystack_glance' |>

  exec { 'glance db sync':
    path        => '/usr/bin',
    command     => 'glance-manage db_sync',
    refreshonly => true,
    logoutput   => 'on_failure',
  }

}
