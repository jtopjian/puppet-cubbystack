# == Class: cubbystack::nova::db_sync
#
# Schedules and performs the `nova-manage db sync` command.
#
# === Example Usage
#
# Please see the `manifests/examples` directory.
#
class cubbystack::nova::db_sync {

  # Order the db sync correctly
  Package<| tag == 'nova' |>  ~> Exec['nova-manage db sync']
  Exec['nova-manage db sync'] ~> Service<| tag == 'nova' |>
  Nova_config<||>             -> Exec['nova-manage db sync']
  Nova_paste_api_ini<||>      -> Exec['nova-manage db sync']
  Exec['nova-manage db sync'] -> Nova_network<||>
  Exec['nova-manage db sync'] -> Nova_floating<||>

  # Configure the nova database
  exec { 'nova-manage db sync':
    path        => '/usr/bin',
    refreshonly => true,
  }

}
