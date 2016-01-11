# == Class: cubbystack::designate::agent
#
# Configures the designate-agent service
#
# === Parameters
#
# [*service_enable*]
#   The status of the designate-agent service
#   Defaults to true
#
# === Example Usage
#
# Please see the `examples` directory.
#
class cubbystack::designate::agent (
  $service_enable   = true,
) {

  include ::cubbystack::designate

  cubbystack::functions::generic_service { 'designate-agent':
    service_enable => $service_enable,
    service_name   => $::cubbystack::params::designate_agent_service_name,
    tags           => $::cubbystack::designate::tags,
  }
}
