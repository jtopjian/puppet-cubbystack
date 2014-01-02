class cubbystack::params {

  case $::osfamily {
    'Debian': {
      # Keystone
      $keystone_package_name   = 'keystone'
      $keystone_service_name   = 'keystone'
      $keystone_package_deps   = ['python-memcache']

      # Glance
      $glance_package_name          = 'glance'
      $glance_api_service_name      = 'glance-api'
      $glance_registry_service_name = 'glance-registry'

      # Cinder
      $cinder_common_package_name    = 'cinder-common'
      $cinder_api_package_name       = 'cinder-api'
      $cinder_api_service_name       = 'cinder-api'
      $cinder_scheduler_package_name = 'cinder-scheduler'
      $cinder_scheduler_service_name = 'cinder-scheduler'
      $cinder_volume_package_name    = 'cinder-volume'
      $cinder_volume_service_name    = 'cinder-volume'

      # Nova
      # nova package names
      $nova_api_package_name         = 'nova-api'
      $nova_cert_package_name        = 'nova-cert'
      $nova_common_package_name      = 'nova-common'
      $nova_compute_package_name     = 'nova-compute'
      $nova_doc_package_name         = 'nova-doc'
      $nova_network_package_name     = 'nova-network'
      $nova_vncproxy_package_name    = 'nova-novncproxy'
      $nova_novnc_package_name       = 'novnc'
      $nova_objectstore_package_name = 'nova-objectstore'
      $nova_scheduler_package_name   = 'nova-scheduler'
      $nova_conductor_package_name   = 'nova-conductor'
      $nova_conductor_service_name   = 'nova-conductor'

      # nova service names
      $nova_api_service_name         = 'nova-api'
      $nova_cert_service_name        = 'nova-cert'
      $nova_compute_service_name     = 'nova-compute'
      $nova_consoleauth_service_name = 'nova-consoleauth'
      $nova_network_service_name     = 'nova-network'
      $nova_vncproxy_service_name    = 'nova-novncproxy'
      $nova_objectstore_service_name = 'nova-objectstore'
      $nova_scheduler_service_name   = 'nova-scheduler'

      # Neutron
      $neutron_common_package_name     = 'neutron-common'
      $neutron_server_package_name     = 'neutron-server'
      $neutron_server_service_name     = 'neutron-server'
      $neutron_dhcp_package_name       = 'neutron-dhcp-agent'
      $neutron_dhcp_service_name       = 'neutron-dhcp-agent'
      $neutron_l3_package_name         = 'neutron-l3-agent'
      $neutron_l3_service_name         = 'neutron-l3-agent'
      $neutron_metadata_package_name   = 'neutron-metadata-agent'
      $neutron_metadata_service_name   = 'neutron-metadata-agent'
      $neutron_plugin_ovs_package_name = 'neutron-plugin-openvswitch-agent'
      $neutron_plugin_ovs_service_name = 'neutron-plugin-openvswitch-agent'


      # Horizon
      $horizon_apache_user           = 'www-data'
      $horizon_apache_group          = 'www-data'
      $horizon_config_file           = '/etc/openstack-dashboard/local_settings.py'

      # Swift
      $swift_package_name                      = 'swift'
      $swift_client_package_name               = 'python-swiftclient'
      $swift_proxy_package_name                = 'swift-proxy'
      $swift_proxy_service_name                = 'swift-proxy'
      $swift_object_package_name               = 'swift-object'
      $swift_object_service_name               = 'swift-object'
      $swift_object_auditor_service_name       = 'swift-object-auditor'
      $swift_object_replicator_service_name    = 'swift-object-replicator'
      $swift_object_updater_service_name       = 'swift-object-updater'
      $swift_container_package_name            = 'swift-container'
      $swift_container_service_name            = 'swift-container'
      $swift_container_auditor_service_name    = 'swift-container-auditor'
      $swift_container_replicator_service_name = 'swift-container-replicator'
      $swift_container_updater_service_name    = 'swift-container-updater'
      $swift_account_package_name              = 'swift-account'
      $swift_account_service_name              = 'swift-account'
      $swift_account_auditor_service_name      = 'swift-account-auditor'
      $swift_account_reaper_service_name       = 'swift-account-reaper'
      $swift_account_replicator_service_name   = 'swift-account-replicator'
      $swift3                                  = 'swift-plugin-s3'

      # debian specific nova config
      $root_helper              = 'sudo nova-rootwrap'
      $lock_path                = '/var/lock/nova'
      $nova_db_charset          = 'latin1'

      # Misc
      $libvirt_package_name     = 'libvirt-bin'
      $libvirt_service_name     = 'libvirt-bin'
      $libvirt_type_kvm         = 'qemu-kvm'
      $numpy_package_name       = 'python-numpy'
      $tgt_package_name         = 'tgt'
      $tgt_service_name         = 'tgt'

      case $::operatingsystem {
        'Debian': {
          $service_provider              = 'undef'
          $nova_consoleauth_package_name = 'nova-console'
          $horizon_package_name          = 'openstack-dashboard-apache'
          $horizon_package_Deps          = []
        }
        default: {
          $service_provider              = 'upstart'
          $nova_consoleauth_package_name = 'nova-consoleauth'
          $horizon_package_name          = 'openstack-dashboard'
          $horizon_package_deps          = ['python-django', 'python-compressor', 'python-appconf', 'python-cloudfiles', 'python-tz', 'node-less']
        }
      }
    }
    'RedHat': {
      # Keystone
      $keystone_package_name = 'openstack-keystone'
      $keystone_service_name = 'openstack-keystone'

      # Glance
      $glance_package_name          = 'openstack-glance'
      $glance_api_service_name      = 'openstack-glance-api'
      $glance_registry_service_name = 'openstack-glance-registry'

      # Nova
      # nova package names
      $nova_api_package_name         = false
      $nova_cert_package_name        = false
      $nova_common_package_name      = 'openstack-nova'
      $nova_compute_package_name     = false
      $nova_consoleauth_package_name = false
      $nova_doc_package_name         = 'openstack-nova-doc'
      $nova_network_package_name     = false
      $nova_objectstore_package_name = false
      $nova_scheduler_package_name   = false
      $nova_vncproxy_package_name    = 'openstack-nova-novncproxy'

      # nova service names
      $nova_api_service_name         = 'openstack-nova-api'
      $nova_cert_service_name        = 'openstack-nova-cert'
      $nova_compute_service_name     = 'openstack-nova-compute'
      $nova_consoleauth_service_name = 'openstack-nova-consoleauth'
      $nova_network_service_name     = 'openstack-nova-network'
      $nova_objectstore_service_name = 'openstack-nova-objectstore'
      $nova_scheduler_service_name   = 'openstack-nova-scheduler'
      $nova_vncproxy_service_name    = 'openstack-nova-novncproxy'

      # Horizon
      $horizon_apache_user           = 'apache'
      $horizon_apache_group          = 'apache'
      $horizon_config_file           = '/etc/openstack-dashboard/local_settings.py'

      # redhat specific config defaults
      $root_helper = 'sudo nova-rootwrap'
      $lock_path   = '/var/lib/nova/tmp'

      # Misc
      $libvirt_package_name = 'libvirt'
      $libvirt_service_name = 'libvirtd'
      $numpy_package_name   = 'numpy'
      $tgt_package_name     = 'scsi-target-utils'
      $tgt_service_name     = 'tgtd'
      $service_provider     = undef
    }
  }

}
