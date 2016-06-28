# == Class: cubbystack::designate::pool-manager-cache
#
# If required this will sync the cache of the pool-manager. This is only required if using the sqlachemy backend
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
