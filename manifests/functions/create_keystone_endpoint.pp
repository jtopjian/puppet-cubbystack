# == Defined Type: cubbystack::functions::create_keystone_endpoint
#
# Creates a Keystone Endpoint.
# At this time, only templated endpoints are supported.
#
# === Parameters
#
# [*service_name*]
#   The name of the OpenStack service
#   Required
#
# [*public_url*]
#   The Public URL of the OpenStack service
#   Required
#
# [*admin_url*]
#   The Admin URL of the OpenStack service
#   Required
#
# [*internal_url*]
#   The Internal URL of the OpenStack service
#   Required
#
# [*catalog_file*]
#   The name of the templated catalog file
#   Defaults to '/etc/keystone/default_catalog.templates'
#
# === Example Usage
#
# Please see the `manifests/examples` directory.
#
define cubbystack::functions::create_keystone_endpoint (
  $service_name,
  $public_url,
  $admin_url,
  $internal_url,
  $catalog_file  = '/etc/keystone/default_catalog.templates'
) {

  include concat::setup

  $x = split($name, '/')
  $region = $x[0]
  $service = $x[1]

  concat::fragment { "Keystone Catalog: ${name}":
    target  => $catalog_file,
    content => template('cubbystack/keystone/endpoint.erb'),
    order   => 2,
  }

}
