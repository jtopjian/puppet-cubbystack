class cubbystack::examples::roles::controller {

  class { 'cubbystack::examples::roles::controller::users': } ->
  class { 'cubbystack::examples::roles::controller::packages': } ->
  class { 'cubbystack::examples::roles::controller::mysql': } ->
  class { 'cubbystack::examples::roles::controller::keystone': } ->
  class { 'cubbystack::examples::roles::controller::glance': } ->
  class { 'cubbystack::examples::roles::controller::cinder': } ->
  class { 'cubbystack::examples::roles::controller::horizon': } ->
  class { 'cubbystack::examples::roles::controller::nova': }

}
