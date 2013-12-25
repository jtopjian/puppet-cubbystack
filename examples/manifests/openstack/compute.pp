class site::openstack::compute {

  anchor { 'site::openstack::compute': } ->

  class { '::cubbystack::repo': } ->
  class { 'site::openstack::users': } ->
  class { 'site::openstack::compute::packages': } ->
  class { 'site::openstack::compute::nova': } ->
  class { 'site::openstack::compute::neutron': } ->
  class { 'site::openstack::compute::libvirt': }

}
