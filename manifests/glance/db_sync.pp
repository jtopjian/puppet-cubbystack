# == Class: cubbystack::glance::db_sync
#
# Schedules and performs the `glance-manage db_sync` command.
#
class cubbystack::glance::db_sync {

  # Order and notifications
  Package<| tag == 'cubbystack_glance' |> ~> Exec['glance-manage db_sync']
  Cubbystack_config<| tag == 'cubbystack_glance' |> -> Exec['glance-manage db_sync']
  Exec['glance-manage db_sync'] -> Service<| tag == 'cubbystack_glance' |>

  exec { 'glance-manage db_sync':
    path        => '/usr/bin',
    refreshonly => true,
    logoutput   => 'on_failure',
  }

}
