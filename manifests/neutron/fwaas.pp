# == Class: cubbystack::neutron::fwaas
#
# Configures the neutron-fwaas
#
# === Parameters
#
# [*settings*]
#   A hash of key => value settings to go in fwaas_agent.ini
#
# [*config_file*]
#   The path to fwaas_agent.ini
#   Defaults to /etc/neutron/fwaas_agent.ini
#
class cubbystack::neutron::fwaas (
  $settings,
  $package_ensure = latest,
  $config_file    = '/etc/neutron/fwaas_driver.ini',
) {

  include ::cubbystack::params

  ## Meta settings and globals
  $tags = ['openstack', 'neutron', 'neutron-fwaas']

  # Make sure Neutron FWaaS is installed before any configuration begins
  # Make sure Neutron FWaaS is configured before the service starts
  Package<| tag == 'neutron' |> -> Cubbystack_config<| tag == 'neutron-fwaas' |>
  Package<| tag == 'neutron' |> -> File<| tag == 'neutron-fwaas' |>

  # Restart neutron-fwaas after any config changes
  Cubbystack_config<| tag == 'neutron-fwaas' |> ~> Service<| tag == 'neutron' |>

  File {
    ensure => present,
    owner  => 'neutron',
    group  => 'neutron',
    mode   => '0640',
    tag    => $tags,
  }

  ## Neutron FWaaS configuration
  file { $config_file: }

  # Configure the FWaaS service
  $settings.each |$setting, $value| {
    cubbystack_config { "${config_file}: ${setting}":
      value => $value,
      tag   => $tags,
    }
  }

}
