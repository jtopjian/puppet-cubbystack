# == Defined Type: cubbystack::functions::create_keystone_project
#
# Creates a Keystone project.
#
# == Parameters
#
# [*name*]
#   The project name in the format 'domain/project'.
#   Required
#
# [*openrc_file*]
#   The location of an openrc file on the server where this is run.
#   Defaults to '/root/openrc'
#
define cubbystack::functions::create_keystone_project (
  $openrc_file = '/root/openrc',
) {

  $x = split($name, '/')
  $domain = $x[0]
  $project = $x[1]

  $command = "openstack project create --domain \"${domain}\" \"${project}\""
  $_unless  = "openstack project show --domain \"${domain}\" ${project}"

  exec { "cubbystack openstack project ${name}":
    command => "/bin/bash -c 'source ${openrc_file} && ${command}'",
    unless  => "/bin/bash -c 'source ${openrc_file} && ${_unless}'",
  }
}
