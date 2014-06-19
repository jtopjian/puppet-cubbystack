class cubbystack::roles::compute {

  anchor { 'cubbystack::roles::compute': } ->

  class { 'cubbystack::roles::compute::packages': } ->
  class { 'cubbystack::roles::compute::users': } ->
  class { 'cubbystack::roles::compute::nova': } ->
  class { 'cubbystack::roles::compute::libvirt': }

}
