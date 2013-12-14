class site::openstack::compute {

  anchor { 'site::openstack::compute': } ->

  class { 'site::openstack::compute::packages': } ->
  class { 'site::openstack::compute::users': } ->
  class { 'site::openstack::compute::nova': } ->
  class { 'site::openstack::compute::neutron': } ->
  class { 'site::openstack::compute::libvirt': }

}
