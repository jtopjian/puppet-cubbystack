# == Defined Type: cubbystack::functions::create_keystone_role_assignment
#
# Creates a Keystone role assignment.
#
# == Parameters
#
# [*name*]
#   The role assignment name in the format 'project/user/role'
#   Required
#
# [*openrc_file*]
#   The location of an openrc file on the server where this is run.
#   Defaults to '/root/openrc'
#
define cubbystack::functions::create_keystone_role_assignment (
  $openrc_file = '/root/openrc',
) {

  $x = split($name, '/')
  $project  = $x[0]
  $username = $x[1]
  $role     = $x[2]

  $command = "openstack role add --user \"${username}\" --project \"${project}\" \"${role}\""
  $unless = "openstack role assignment list --names --user \"${username}\" --project \"${project}\" --role \"${role}\" | grep -q ${username}"

  exec { "cubbystack openstack role ${name}":
    command => "/bin/bash -c 'source ${openrc_file} && ${command}'",
    unless  => "/bin/bash -c 'source ${openrc_file} && ${unless}'",
  }
}
