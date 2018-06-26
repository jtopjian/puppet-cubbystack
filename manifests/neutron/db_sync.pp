# == Class: cubbystack::neutron::db_sync
#
# Schedules and performs the `neutron-manage db sync` command.
#
class cubbystack::neutron::db_sync {

  # Order the db sync correctly
  Package<| tag == 'cubbystack_neutron' |>           ~> Exec['neutron db sync']
  Cubbystack_config<| tag == 'cubbystack_neutron' |> -> Exec['neutron db sync']
  Exec['neutron db sync']                            ~> Service<| tag == 'cubbystack_neutron' |>

  # Configure the neutron database
  exec { 'neutron db sync':
    path        => '/usr/bin',
    command     => 'neutron-db-manage upgrade heads',
    refreshonly => true,
    logoutput   => 'on_failure',
  }

}
