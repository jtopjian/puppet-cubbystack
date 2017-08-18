class cubbystack::params {

  case $::osfamily {
    'Debian': {

      # Utils / Misc
      $openstack_utils = false

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
      $nova_api_package_name          = 'nova-api'
      $nova_cert_package_name         = 'nova-cert'
      $nova_common_package_name       = 'nova-common'
      $nova_compute_package_name      = 'nova-compute'
      $nova_doc_package_name          = 'nova-doc'
      $nova_network_package_name      = 'nova-network'
      $nova_vncproxy_package_name     = 'nova-novncproxy'
      $nova_novnc_package_name        = 'novnc'
      $nova_objectstore_package_name  = 'nova-objectstore'
      $nova_scheduler_package_name    = 'nova-scheduler'
      $nova_conductor_package_name    = 'nova-conductor'
      $nova_api_metadata_package_name = 'nova-api-metadata'
      $nova_cells_package_name        = 'nova-cells'

      # nova service names
      $nova_api_service_name          = 'nova-api'
      $nova_cert_service_name         = 'nova-cert'
      $nova_compute_service_name      = 'nova-compute'
      $nova_consoleauth_service_name  = 'nova-consoleauth'
      $nova_network_service_name      = 'nova-network'
      $nova_vncproxy_service_name     = 'nova-novncproxy'
      $nova_objectstore_service_name  = 'nova-objectstore'
      $nova_scheduler_service_name    = 'nova-scheduler'
      $nova_conductor_service_name    = 'nova-conductor'
      $nova_api_metadata_service_name = 'nova-api-metadata'
      $nova_cells_service_name        = 'nova-cells'

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
      $neutron_lbaas_package_name      = 'neutron-lbaas-agent'
      $neutron_lbaas_service_name      = 'neutron-lbaas-agent'
      $neutron_plugin_ovs_package_name = 'neutron-plugin-openvswitch-agent'
      $neutron_plugin_ovs_service_name = 'neutron-plugin-openvswitch-agent'
      $neutron_plugin_ml2_package_name = 'neutron-plugin-ml2'
      #$neutron_plugin_linuxbridge_package_name = 'neutron-plugin-linuxbridge-agent'
      #$neutron_plugin_linuxbridge_service_name = 'neutron-plugin-linuxbridge-agent'

      case $::lsbdistcodename {
        'xenial': {
          $neutron_plugin_linuxbridge_package_name = 'neutron-linuxbridge-agent'
          $neutron_plugin_linuxbridge_service_name = 'neutron-linuxbridge-agent'
          $neutron_plugin_sriov_package_name       = 'neutron-sriov-agent'
          $neutron_plugin_sriov_service_name       = 'neutron-sriov-agent'
          $keystone_package_name                   = 'keystone'
          $keystone_service_name                   = 'keystone'
          #$keystone_service_name                   = 'apache2'
        }
        default: {
          $neutron_plugin_linuxbridge_package_name = 'neutron-plugin-linuxbridge-agent'
          $neutron_plugin_linuxbridge_service_name = 'neutron-plugin-linuxbridge-agent'
          $neutron_plugin_sriov_package_name       = 'neutron-plugin-sriov-agent'
          $neutron_plugin_sriov_service_name       = 'neutron-plugin-sriov-agent'
          $keystone_package_name                   = 'keystone'
          $keystone_service_name                   = 'keystone'
        }
      }

      # Horizon
      $horizon_apache_user           = 'horizon'
      $horizon_apache_group          = 'horizon'
      $horizon_config_file           = '/etc/openstack-dashboard/local_settings.py'

      # Swift
      $swift_package_name                      = 'swift'
      $swift_client_package_name               = 'python-swiftclient'
      $swift_expirer_package_name              = 'swift-object-expirer'
      $swift_expirer_service_name              = 'swift-object-expirer'
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
      $swift_container_sync_service_name       = 'swift-container-sync'
      $swift_container_updater_service_name    = 'swift-container-updater'
      $swift_account_package_name              = 'swift-account'
      $swift_account_service_name              = 'swift-account'
      $swift_account_auditor_service_name      = 'swift-account-auditor'
      $swift_account_reaper_service_name       = 'swift-account-reaper'
      $swift_account_replicator_service_name   = 'swift-account-replicator'
      $swift3                                  = 'swift-plugin-s3'

      # Heat
      $heat_common_package_name         = 'heat-common'
      $heat_api_package_name            = 'heat-api'
      $heat_api_service_name            = 'heat-api'
      $heat_api_cfn_package_name        = 'heat-api-cfn'
      $heat_api_cfn_service_name        = 'heat-api-cfn'
      $heat_api_cloudwatch_package_name = 'heat-api-cloudwatch'
      $heat_api_cloudwatch_service_name = 'heat-api-cloudwatch'
      $heat_engine_package_name         = 'heat-engine'
      $heat_engine_service_name         = 'heat-engine'

      # Trove
      $trove_common_package_name      = 'trove-common'
      $trove_api_package_name         = 'trove-api'
      $trove_api_service_name         = 'trove-api'
      $trove_taskmanager_package_name = 'trove-taskmanager'
      $trove_taskmanager_service_name = 'trove-taskmanager'
      $trove_conductor_package_name   = false
      $trove_conductor_service_name   = 'trove-conductor'

      # Murano
      $murano_common_package_name = 'murano-common'
      $murano_api_package_name    = 'murano-api'
      $murano_api_service_name    = 'murano-api'
      $murano_engine_package_name = 'murano-engine'
      $murano_engine_service_name = 'murano-engine'
      $murano_cfapi_package_name  = 'murano-cfapi'
      $murano_cfapi_service_name  = 'murano-cfapi'

      # Designate
      $designate_common_package_name       = 'designate'
      $designate_agent_service_name        = 'designate-agent'
      $designate_api_service_name          = 'designate-api'
      $designate_central_service_name      = 'designate-central'
      $designate_mdns_package_name         = 'designate-mdns'
      $designate_mdns_service_name         = 'designate-mdns'
      $designate_pool_manager_package_name = 'designate-pool-manager'
      $designate_pool_manager_service_name = 'designate-pool-manager'
      $designate_sink_package_name         = 'designate-sink'
      $designate_sink_service_name         = 'designate-sink'
      $designate_zone_manager_package_name = 'designate-zone-manager'
      $designate_zone_manager_service_name = 'designate-zone-manager'

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
          $horizon_package_deps          = false
        }
        default: {
          case $::lsbdistcodename {
            'trusty': {
              $service_provider          = 'upstart'
            }
            default: {
              $service_prodiver          = 'systemd'
            }
          }
          $nova_consoleauth_package_name = 'nova-consoleauth'
          $horizon_package_name          = 'openstack-dashboard'
          $horizon_package_deps          = ['python-django', 'python-compressor', 'python-appconf', 'python-cloudfiles', 'python-tz', 'node-less']
        }
      }
    }
    'RedHat': {

      # Utils / Misc
      $openstack_utils = ['openstack-utils', 'openstack-selinux']

      # Keystone
      $keystone_package_name = 'openstack-keystone'
      $keystone_service_name = 'openstack-keystone'

      # Glance
      $glance_package_name          = 'openstack-glance'
      $glance_api_service_name      = 'openstack-glance-api'
      $glance_registry_service_name = 'openstack-glance-registry'

      # Cinder
      $cinder_common_package_name    = 'openstack-cinder'
      $cinder_api_package_name       = false
      $cinder_api_service_name       = 'openstack-cinder-api'
      $cinder_scheduler_package_name = false
      $cinder_scheduler_service_name = 'openstack-cinder-scheduler'
      $cinder_volume_package_name    = false
      $cinder_volume_service_name    = 'openstack-cinder-volume'

      # Nova
      # nova package names
      $nova_api_package_name         = false
      $nova_cert_package_name        = false
      $nova_common_package_name      = 'openstack-nova'
      $nova_compute_package_name     = 'openstack-nova-compute'
      $nova_doc_package_name         = 'openstack-nova-doc'
      $nova_network_package_name     = 'openstack-nova-network'
      $nova_vncproxy_package_name    = 'openstack-nova-novncproxy'
      $nova_objectstore_package_name = false
      $nova_scheduler_package_name   = false
      $nova_conductor_package_name   = false

      # nova service names
      $nova_api_service_name         = 'openstack-nova-api'
      $nova_cert_service_name        = 'openstack-nova-cert'
      $nova_compute_service_name     = 'openstack-nova-compute'
      $nova_consoleauth_service_name = 'openstack-nova-consoleauth'
      $nova_network_service_name     = 'openstack-nova-network'
      $nova_objectstore_service_name = 'openstack-nova-objectstore'
      $nova_scheduler_service_name   = 'openstack-nova-scheduler'
      $nova_vncproxy_service_name    = 'openstack-nova-novncproxy'
      $nova_conductor_service_name   = 'openstack-nova-conductor'

      # Neutron
      $neutron_common_package_name     = 'openstack-neutron'
      $neutron_server_package_name     = false
      $neutron_server_service_name     = 'neutron-server'
      $neutron_dhcp_package_name       = false
      $neutron_dhcp_service_name       = 'neutron-dhcp-agent'
      $neutron_l3_package_name         = false
      $neutron_l3_service_name         = 'neutron-l3-agent'
      $neutron_metadata_package_name   = false
      $neutron_metadata_service_name   = 'neutron-metadata-agent'
      $neutron_plugin_ovs_package_name = 'openstack-neutron-openvswitch'
      $neutron_plugin_ovs_service_name = 'neutron-openvswitch-agent'

      # Horizon
      $horizon_package_name          = 'openstack-dashboard'
      $horizon_package_deps          = false
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
