# == Class: cubbystack::designate::central
#
# Configures the designate-central service
#
# === Parameters
#
# [*service_enable*]
#   The status of the designate-central service
#   Defaults to true
#
# === Example Usage
#
# Please see the `examples` directory.
#
class cubbystack::designate::central (
  $service_enable   = true,
) {

  include ::cubbystack::designate

  cubbystack::functions::generic_service { 'designate-central':
    service_enable => $service_enable,
    service_name   => $::cubbystack::params::designate_central_service_name,
    tags           => $::cubbystack::designate::tags,
  }
}
