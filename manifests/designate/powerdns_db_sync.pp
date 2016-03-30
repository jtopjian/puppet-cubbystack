# == Class: cubbystack::designate::powerdns_db_sync
#
# Schedules and performs the `designate-manage powerdns sync <pool-target>` command.
# Assumes only one pool will exist and the default pool uses PowerDNS
#
class cubbystack::designate::powerdns_db_sync {

  include ::cubbystack::designate

  # Order and notifications
  Package<| tag == 'designate' |>           ~> Exec['designate-manage powerdns sync']
  Cubbystack_config<| tag == 'designate' |> -> Exec['designate-manage powerdns sync']
  Exec['designate-manage powerdns sync']          -> Service<| tag == 'designate' |>

  exec { 'designate-manage powerdns sync':
    command     => "designate-manage powerdns sync ${::cubbystack::params::designate_default_pool_id}",
    path        => '/usr/bin',
    refreshonly => true,
    logoutput   => 'on_failure',
  }

}
