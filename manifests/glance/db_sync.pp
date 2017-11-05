# == Class: cubbystack::glance::db_sync
#
# Schedules and performs the `glance-manage db_sync` command.
#
class cubbystack::glance::db_sync {

  # Order and notifications
  Package['glance']                      ~> Exec['glance-manage db_sync']
  Cubbystack_config<| tag == 'glance' |> -> Exec['glance-manage db_sync']
  Exec['glance-manage db_sync']          -> Service<| tag == 'glance' |>

  exec { 'glance-manage db_sync':
    path        => '/usr/bin',
    refreshonly => true,
    logoutput   => 'on_failure',
  }

}
