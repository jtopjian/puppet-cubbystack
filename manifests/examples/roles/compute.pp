class cubbystack::examples::roles::compute {

  class { 'cubbystack::examples::roles::compute::users': } ->
  class { 'cubbystack::examples::roles::compute::node': } ->
  class { 'cubbystack::examples::roles::compute::libvirt': }

}
