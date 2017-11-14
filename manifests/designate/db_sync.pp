# == Class: cubbystack::designate::db_sync
#
# Schedules and performs the `designate-manage database sync` command.
#
# === Example Usage
#
# Please see the `examples` directory.
#
class cubbystack::designate::db_sync {

  # Order and notifications
  Package<| tag == 'cubbystack_designate' |> ~> Exec['designate-manage database sync']
  Cubbystack_config<| tag == 'cubbystack_designate' |> -> Exec['designate-manage database sync']
  Exec['designate-manage database sync'] -> Service<| tag == 'cubbystack_designate' |>

  exec { 'designate-manage database sync':
    path        => '/usr/bin',
    refreshonly => true,
    logoutput   => 'on_failure',
  }

}
