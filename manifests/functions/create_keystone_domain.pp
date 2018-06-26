# == Defined Type: cubbystack::functions::create_keystone_domain
#
# Creates a Keystone domain.
#
# == Parameters
#
# [*name*]
#   The domain name.
#   Required
#
# [*openrc_file*]
#   The location of an openrc file on the server where this is run.
#   Defaults to '/root/openrc'
#
define cubbystack::functions::create_keystone_domain (
  $openrc_file = '/root/openrc',
) {

  $command = "openstack domain create \"${name}\""
  $unless = "openstack domain show \"${name}\""

  exec { "cubbystack openstack domain ${name}":
    command => "/bin/bash -c 'source ${openrc_file} && ${command}'",
    unless  => "/bin/bash -c 'source ${openrc_file} && ${unless}'",
  }
}
