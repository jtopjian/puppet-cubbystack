# == Class: cubbystack::cinder::db_sync
#
# Schedules and performs the `cinder-manage db sync` command.
#
class cubbystack::cinder::db_sync {

  # Order the db sync correctly
  Package<| tag == 'cinder' |>           ~> Exec['cinder-manage db sync']
  Cubbystack_config<| tag == 'cinder' |> -> Exec['cinder-manage db sync']
  Exec['cinder-manage db sync']          ~> Service<| tag == 'cinder' |>

  # Configure the cinder database
  exec { 'cinder-manage db sync':
    path        => '/usr/bin',
    refreshonly => true,
    logoutput   => 'on_failure',
  }

}
