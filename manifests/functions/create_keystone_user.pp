# == Defined Type: cubbystack::functions::create_keystone_user
#
# Creates a Keystone user.
#
# == Parameters
#
# [*name*]
#   The username in the format 'default_project/username'.
#   Required
#
# [*password*]
#   The password of the user.
#   Required
#
# [*openrc_file*]
#   The location of an openrc file on the server where this is run.
#   Defaults to '/root/openrc'
#
define cubbystack::functions::create_keystone_user (
  $password,
  $openrc_file = '/root/openrc',
) {

  $x = split($name, '/')
  $project  = $x[0]
  $username = $x[1]

  $command = "openstack user create --password \"${password}\" --project \"${project}\" ${username}"
  $unless  = "openstack user show ${username}"

  exec { "cubbystack openstack user: ${name}":
    path    => ['/usr/bin'],
    command => "/bin/bash -c 'source ${openrc_file} && ${command}'",
    unless  => "/bin/bash -c 'source ${openrc_file} && ${unless}'",
  }
}
