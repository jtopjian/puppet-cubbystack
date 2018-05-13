# == Class: cubbystack::nova
#
# Configures the nova-common package and nova.conf
#
# === Parameters
#
# [*settings*]
#   A hash of key => value settings to go in cinder.conf
#
# [*package_ensure*]
#   The status of the nova-common package
#   Defaults to present
#
# [*config_file*]
#   The path to nova.conf
#   Defaults to /etc/nova/nova.conf
#
class cubbystack::nova (
  $settings,
  $package_ensure = present,
  $config_file    = '/etc/nova/nova.conf',
) {

  contain ::cubbystack::params

  ## Meta settings and globals
  $tags = ['cubbystackopenstack', 'cubbystack_nova']

  # Make sure nova is installed before configuration begins
  Package<| tag == 'cubbystack_nova' |> -> Cubbystack_config<| tag == 'cubbystack_nova' |>
  Cubbystack_config<| tag == 'cubbystack_nova' |> -> Service<| tag == 'cubbystack_nova' |>

  # Restart nova services whenever nova.conf has been changed
  Cubbystack_config<| tag == 'cubbystack_nova' |> ~> Service<| tag == 'cubbystack_nova' |>
  Cubbystack_config<| tag == 'cubbystack_nova' |> ~> Exec<| tag == 'cubbystack_nova_placement_apache' |>

  # Global file attributes
  File {
    ensure  => present,
    owner   => 'nova',
    group   => 'nova',
    mode    => '0640',
    tag     => $tags,
    require => Package['nova-common'],
  }

  # nova-common package
  package { 'nova-common':
    ensure => $package_ensure,
    name   => $::cubbystack::params::nova_common_package_name,
    tag    => $tags,
  }

  ## Nova configuration files
  file { '/var/log/nova':
    ensure  => directory,
    recurse => true,
  }

  file { '/etc/nova':
    ensure  => directory,
    recurse => true,
  }

  file { $config_file: }

  # nova-manage insists on 0644
  file { '/var/log/nova/nova-manage.log':
    mode => '0644',
  }

  ## Configure nova.conf
  $settings.each |$setting, $value| {
    cubbystack_config { "${config_file}: ${setting}":
      value => $value,
      tag   => $tags,
    }
  }

}
