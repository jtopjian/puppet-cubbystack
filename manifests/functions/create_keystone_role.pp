# == Defined Type: cubbystack::functions::create_keystone_role
#
# Creates a Keystone role.
#
# == Parameters
#
# [*name*]
#   The role name.
#   Required
#
# [*openrc_file*]
#   The location of an openrc file on the server where this is run.
#   Defaults to '/root/openrc'
#
define cubbystack::functions::create_keystone_role (
  $openrc_file = '/root/openrc',
) {

  $command = "openstack role create \"${name}\""
  $unless  = "openstack role show \"${name}\""

  exec { "cubbystack openstack role ${name}":
    command => "/bin/bash -c 'source ${openrc_file} && ${command}'",
    unless  => "/bin/bash -c 'source ${openrc_file} && ${unless}'",
  }
}
