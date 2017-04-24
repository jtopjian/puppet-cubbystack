# == Class: cubbystack::neutron::db_sync
#
# Schedules and performs the `neutron-manage db sync` command.
#
class cubbystack::neutron::db_sync {

  # Order the db sync correctly
  Package<| tag == 'neutron' |>           ~> Exec['neutron-db-manage upgrade heads']
  Cubbystack_config<| tag == 'neutron' |> -> Exec['neutron-db-manage upgrade heads']
  Exec['neutron-db-manage upgrade heads'] ~> Service<| tag == 'neutron' |>

  # Configure the neutron database
  exec { 'neutron-db-manage upgrade heads':
    path        => '/usr/bin',
    refreshonly => true,
    logoutput   => 'on_failure',
  }

}
