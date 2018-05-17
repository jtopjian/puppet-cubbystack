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
  Package<| tag == 'cubbystack_designate' |>           ~> Exec['designate db sync']
  Cubbystack_config<| tag == 'cubbystack_designate' |> -> Exec['designate db sync']
  Exec['designate db sync']                            -> Service<| tag == 'cubbystack_designate' |>

  exec { 'designate db sync':
    path        => '/usr/bin',
    command     => 'designate-manage database sync',
    refreshonly => true,
    logoutput   => 'on_failure',
  }

}
