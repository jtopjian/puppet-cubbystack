# == Class: cubbystack::glance::db_sync
#
# Schedules and performs the `glance-manage db_sync` command.
#
# === Example Usage
#
# Please see the `examples` directory.
#
class cubbystack::glance::db_sync {

  # Order and notifications
  Package<| tag == 'glance' |>           ~> Exec['glance-manage db_sync']
  Cubbystack_config<| tag == 'glance' |> -> Exec['glance-manage db_sync']
  Exec['glance-manage db_sync']          -> Service<| tag == 'glance' |>

  exec { 'glance-manage db_sync':
    path        => '/usr/bin',
    refreshonly => true,
  }

}
