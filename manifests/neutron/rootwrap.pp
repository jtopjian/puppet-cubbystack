# == Class: cubbystack::neutron::rootwrap
#
# Configures rootwrap for neutron
#
# === Parameters
#
# [*settings*]
#   A hash of key => value settings to go in rootwrap.conf
#
# [*config_file*]
#   The path to rootwrap.conf
#   Defaults to /etc/neutron/rootwrap.conf
#
class cubbystack::neutron::rootwrap (
  $settings,
  $config_file = '/etc/neutron/rootwrap.conf',
) {

  ## Meta settings and globals
  $tags = ['cubbystack_openstack', 'cubbystack_neutron']

  # Global file attributes
  File {
    ensure  => present,
    owner   => 'neutron',
    group   => 'neutron',
    mode    => '0640',
    tag     => $tags,
    require => Package['neutron-common'],
  }

  file { $config_file: }

  $settings.each |$setting, $value| {
    cubbystack_config { "${config_file}: ${setting}":
      value => $value,
      tag   => $tags,
    }
  }
}
