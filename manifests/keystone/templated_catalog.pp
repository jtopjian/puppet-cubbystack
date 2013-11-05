# == Class: cubbystack::keystone::templated_catalog
#
# Provides concat support for a templated keystone catalog
#
# === Parameters
#
# [*catalog_file*]
#   The location of the catalog file
#   Defaults to '/etc/keystone/default_catalog.templates'
#
# === Example Usage
#
# Please see the `examples` directory.
#
class cubbystack::keystone::templated_catalog (
  $catalog_file = '/etc/keystone/default_catalog.templates'
) {

  concat { $catalog_file:
    owner => 'keystone',
    group => 'keystone',
    mode  => '0644',
  }

}
