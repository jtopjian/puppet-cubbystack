# == Class: cubbystack::glance::db_sync
#
# Schedules and performs the `glance-manage db_sync` command.
#
# === Example Usage
#
# Please see the `manifests/examples` directory.
#
class cubbystack::glance::db_sync {

  # Order and notifications
  Package<| tag == 'glance' |>  ~> Exec['glance-manage db_sync']
  Glance_api_config<||>         -> Exec['glance-manage db_sync']
  Glance_cache_config<||>       -> Exec['glance-manage db_sync']
  Glance_registry_config<||>    -> Exec['glance-manage db_sync']
  Exec['glance-manage db_sync'] -> Service<| tag == 'glance' |>

  exec { 'glance-manage db_sync':
    path        => '/usr/bin',
    refreshonly => true,
  }

}
