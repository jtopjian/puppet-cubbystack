# == Class: cubbystack::sahara
#
# Configures the sahara-common package and sahara.conf
#
# === Parameters
#
# [*settings*]
#   A hash of key => value settings to go in cinder.conf
#
# [*package_ensure*]
#   The status of the sahara-common package
#   Defaults to present
#
# [*config_file*]
#   The path to sahara.conf
#   Defaults to /etc/sahara/sahara.conf
#
class cubbystack::sahara (
  $settings,
  $package_ensure = present,
  $config_file    = '/etc/sahara/sahara.conf',
) {

  contain ::cubbystack::params

  ## Meta settings and globals
  $tags = ['cubbystack_openstack', 'cubbystack_sahara']

  # Make sure sahara is installed before configuration begins
  Package<| tag == 'cubbystack_sahara' |> -> Cubbystack_config<| tag == 'cubbystack_sahara' |>
  Cubbystack_config<| tag == 'cubbystack_sahara' |> -> Service<| tag == 'cubbystack_sahara' |>

  # Restart sahara services whenever sahara.conf has been changed
  Cubbystack_config<| tag == 'cubbystack_sahara' |> ~> Service<| tag == 'cubbystack_sahara' |>

  # Global file attributes
  File {
    ensure  => present,
    owner   => 'sahara',
    group   => 'sahara',
    mode    => '0640',
    tag     => $tags,
    require => Package['sahara-common'],
  }

  # sahara-common package
  package { 'sahara-common':
    name   => $::cubbystack::params::sahara_common_package_name,
    ensure => present,
    tag    => $tags,
  }

  ## Sahara configuration files
  file { '/etc/sahara':
    ensure  => directory,
    recurse => true,
  }

  file { $config_file: }

  ## Configure sahara.conf
  $settings.each |$setting, $value| {
    cubbystack_config { "${config_file}: ${setting}":
      value => $value,
      tag   => $tags,
    }
  }

}
