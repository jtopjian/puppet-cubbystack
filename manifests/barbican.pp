# == Class: cubbystack::barbican
#
# Configures the barbican-common package and barbican.conf
#
# === Parameters
#
# [*settings*]
#   A hash of key => value settings to go in barbican.conf
#
# [*config_file*]
#   The path to barbican.conf
#   Defaults to /etc/barbican/barbican.conf
#
# [*package_ensure*]
#   The status of the barbican-common package
#   Defaults to present
#
class cubbystack::barbican (
  $settings,
  $package_ensure = present,
  $config_file    = '/etc/barbican/barbican.conf',
) {

  include ::cubbystack::params

  ## Meta settings and globals
  $tags = ['cubbystack_openstack', 'cubbystack_barbican']

  # Make sure barbican is installed before configuration begins
  Package<| tag == 'cubbystack_barbican' |> -> Cubbystack_config<| tag == 'cubbystack_barbican' |>
  Cubbystack_config<| tag == 'cubbystack_barbican' |> -> Service<| tag == 'cubbystack_barbican' |>
  Cubbystack_config<| tag == 'cubbystack_barbican' |> -> Exec<| tag == 'cubbystack_barbican_api_apache' |>

  # Restart barbican services whenever barbican.conf has been changed
  Cubbystack_config<| tag == 'cubbystack_barbican' |> ~> Service<| tag == 'cubbystack_barbican' |>
  Cubbystack_config<| tag == 'cubbystack_barbican' |> ~> Exec<| tag == 'cubbystack_barbican_api_apache' |>

  # Global file attributes
  File {
    ensure  => present,
    owner   => 'barbican',
    group   => 'barbican',
    mode    => '0640',
    tag     => $tags,
    require => Package['barbican-common'],
  }

  # barbican-common package
  package { 'barbican-common':
    ensure => $package_ensure,
    name   => $::cubbystack::params::barbican_common_package_name,
    tag    => $tags,
  }

  ## Barbican configuration files
  file { '/etc/barbican':
    ensure  => directory,
    recurse => true,
  }

  file { '/var/log/barbican': ensure => directory }
  file { $config_file: }

  # Configure barbican.conf
  $settings.each |$setting, $value| {
    cubbystack_config { "${config_file}: ${setting}":
      value => $value,
      tag   => $tags,
    }
  }

}
