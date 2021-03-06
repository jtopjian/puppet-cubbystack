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
  $config_file = '/etc/neutron/fwaas_driver.ini',
) {

  contain ::cubbystack::params

  ## Meta settings and globals
  $tags = ['cubbystack_openstack', 'cubbystack_neutron', 'neutron-fwaas']

  # Make sure Neutron FWaaS is installed before any configuration begins
  # Make sure Neutron FWaaS is configured before the service starts
  Package<| tag == 'cubbystack_neutron' |> -> Cubbystack_config<| tag == 'neutron-fwaas' |>
  Package<| tag == 'cubbystack_neutron' |> -> File<| tag == 'neutron-fwaas' |>

  # Restart neutron-fwaas after any config changes
  Cubbystack_config<| tag == 'neutron-fwaas' |> ~> Service<| tag == 'cubbystack_neutron' |>

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
