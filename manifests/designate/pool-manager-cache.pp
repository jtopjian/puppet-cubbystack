# == Class: cubbystack::designate::pool-manager-cache
#
# Schedules and performs the `designate-manage powerdns sync <pool-target>` command.
# Assumes only one pool will exist and the default pool uses PowerDNS
#
# === Example Usage
#
# Please see the `examples` directory.
#
class cubbystack::designate::pool-manager-cache {

  # Order and notifications
  Package<| tag == 'designate' |>           ~> Exec['designate-manage pool-manager-cache sync']
  Cubbystack_config<| tag == 'designate' |> -> Exec['designate-manage pool-manager-cache sync']
  Exec['designate-manage pool-manager-cache sync']          -> Service<| tag == 'designate' |>

  exec { 'designate-manage pool-manager-cache sync':
    command     => "designate-manage pool-manager-cache sync",
    path        => '/usr/bin',
    refreshonly => true,
    logoutput   => 'on_failure',
  }

}
