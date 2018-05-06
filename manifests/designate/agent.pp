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
# [*service_ensure*]
#   The run status of the designate-agent service
#   Defaults to running
#
class cubbystack::designate::agent (
  $package_ensure = present,
  $service_enable = true,
  $service_ensure = 'running',
) {

  include ::cubbystack::designate

  cubbystack::functions::generic_service { 'designate-agent':
    service_enable    => $service_enable,
    service_ensure    => $service_ensure,
    service_name      => $::cubbystack::params::designate_agent_service_name,
    package_ensure    => $package_ensure,
    package_name      => $::cubbystack::params::designate_agent_package_name,
    tags              => $::cubbystack::designate::tags,
  }
}
