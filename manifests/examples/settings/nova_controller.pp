class cubbystack::examples::settings::nova_controller {
  $nova_controller_settings = {
    conf => {
      'DEFAULT/use_syslog'               => true,
      'DEFAULT/syslog_log_facility'      => 'LOG_LOCAL0',
      'DEFAULT/verbose'                  => true,
      'DEFAULT/log_dir'                  => '/var/log/nova',
      'DEFAULT/state_path'               => '/var/lib/nova',
      'DEFAULT/lock_path'                => '/var/lock/nova',
      'DEFAULT/auth_strategy'            => 'keystone',
      'DEFAULT/rootwrap_config'          => '/etc/nova/rootwrap.conf',
      'DEFAULT/enabled_apis'             => 'ec2,osapi_compute,metadata',
      'DEFAULT/notification_driver'      => 'nova.openstack.common.notifier.rabbit_notifier',
      'DEFAULT/notification_topics'      => 'monitor',
      'DEFAULT/sql_connection'           => 'mysql://nova:password@localhost/nova',
      'DEFAULT/glance_api_servers'       => 'localhost:9292',
      'DEFAULT/rabbit_host'              => 'localhost',
      'DEFAULT/rabbit_userid'            => 'nova',
      'DEFAULT/rabbit_password'          => 'password',
      'DEFAULT/api_paste_config'         => '/etc/nova/api-paste.ini',
      'DEFAULT/fixed_range'              => '10.0.0.0/24',
      'DEFAULT/vlan_interface'           => 'eth1',
      'DEFAULT/public_interface'         => 'eth0',
      'DEFAULT/vlan_start'               => '100',
      'DEFAULT/force_dhcp_release'       => true,
      'DEFAULT/dhcp_domain'              => 'novalocal',
      'DEFAULT/dhcpbridge'               => '/usr/bin/nova-dhcpbridge',
      'DEFAULT/dhcpbridge_flagfile'      => '/etc/nova/nova.conf',
    },
    paste => {
      'filter:authtoken/auth_host'         => 'localhost',
      'filter:authtoken/auth_port'         => '35357',
      'filter:authtoken/auth_protocol'     => 'http',
      'filter:authtoken/admin_tenant_name' => 'services',
      'filter:authtoken/admin_user'        => 'nova',
      'filter:authtoken/admin_password'    => 'password',
    }
  }
}

