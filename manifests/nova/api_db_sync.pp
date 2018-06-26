# == Class: cubbystack::nova::api_db_sync
#
# Schedules and performs the `nova api_db sync` command.
#
class cubbystack::nova::api_db_sync {

  # Order the db sync correctly
  Package<| tag == 'cubbystack_nova' |>           ~> Exec['nova api_db sync']
  Cubbystack_config<| tag == 'cubbystack_nova' |> -> Exec['nova api_db sync']
  Exec['nova api_db sync']                        ~> Service<| tag == 'cubbystack_nova' |>

  # Configure the nova api database
  exec { 'nova api_db sync':
    path        => '/usr/bin',
    command     => 'nova-manage api_db sync',
    refreshonly => true,
    logoutput   => 'on_failure',
    notify      => Exec['nova-manage cell_v2 map_cell0'],
  }

  exec { 'nova-manage cell_v2 map_cell0':
    path        => '/usr/bin',
    refreshonly => true,
    logoutput   => 'on_failure',
    notify      => Exec['nova-manage cell_v2 create_cell --name=cell1'],
  }

  exec { 'nova-manage cell_v2 create_cell --name=cell1':
    path        => ['/bin', '/usr/bin'],
    refreshonly => true,
    logoutput   => 'on_failure',
    notify      => Exec['nova db sync'],
    unless      => "nova-manage cell_v2 list_cells | grep -q cell1",
  }

}
