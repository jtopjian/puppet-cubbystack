# == Class: cubbystack::swift::rings
#
# Configures the swift rings creation and rebalance
#
# === Parameters
#
# [*part_power*]
#   The part_power of the rings.
#   Required.
#
# [*replicas*]
#   The replicas attribute of the rings.
#   Required.
#
# [*min_part_hours*]
#   The minimum amount of time until the rings can be rebalanced.
#   Required.
#
# === Example Usage
#
# Please see the `examples` directory.
#
class cubbystack::swift::rings (
  $part_power,
  $replicas,
  $min_part_hours
) {

  Exec['create_account']   -> Ring_object_device<||> ~> Exec['rebalance_account']
  Exec['create_container'] -> Ring_object_device<||> ~> Exec['rebalance_container']
  Exec['create_object']    -> Ring_object_device<||> ~> Exec['rebalance_object']

  $rings = ['account', 'container', 'object']
  $rings.each { |$ring|
    exec { "create_${ring}":
      command => "swift-ring-builder /etc/swift/${ring}.builder create ${part_power} ${replicas} ${min_part_hours}",
      path    => ['/usr/bin'],
      creates => "/etc/swift/${ring}.builder",
      before  => Class['::cubbystack::swift::proxy'],
      require => Package['swift'],
    }

    exec { "rebalance_${ring}":
      command     => "swift-ring-builder /etc/swift/${ring}.builder rebalance",
      path        => ['/usr/bin'],
      refreshonly => true,
    }
  }

}
