class cubbystack::examples::settings::nova_compute {
  $cloud_controller = '192.168.1.1'
  $nova_compute_settings = {
    conf                                       => {
      'DEFAULT/use_syslog'                     => true,
      'DEFAULT/syslog_log_facility'            => 'LOG_LOCAL0',
      'DEFAULT/verbose'                        => true,
      'DEFAULT/log_dir'                        => '/var/log/nova',
      'DEFAULT/state_path'                     => '/var/lib/nova',
      'DEFAULT/lock_path'                      => '/var/lock/nova',
      'DEFAULT/enabled_apis'                   => 'ec2,osapi_compute,metadata',
      'DEFAULT/auth_strategy'                  => 'keystone',
      'DEFAULT/rootwrap_config'                => '/etc/nova/rootwrap.conf',
      'DEFAULT/sql_connection'                 => "mysql://nova:password@${cloud_controller}/nova",
      'DEFAULT/notification_driver'            => 'nova.openstack.common.notifier.rabbit_notifier',
      'DEFAULT/notification_topics'            => 'monitor',
      'DEFAULT/glance_api_servers'             => "${cloud_controller}:9292",
      'DEFAULT/rabbit_host'                    => $cloud_controller,
      'DEFAULT/rabbit_userid'                  => 'nova',
      'DEFAULT/rabbit_password'                => 'password',
      'DEFAULT/api_paste_config'               => '/etc/nova/api-paste.ini',
      'DEFAULT/libvirt_use_virtio_for_bridges' => true,
      'DEFAULT/compute_driver'                 => 'libvirt.LibvirtDriver',
      'DEFAULT/libvirt_type'                   => 'qemu',
      'DEFAULT/connection_type'                => 'libvirt',
      'DEFAULT/vncserver_proxyclient_address'  => $cloud_controller,
      'DEFAULT/vncserver_listen'               => '0.0.0.0',
      'DEFAULT/novncproxy_base_url'            => "http://{$cloud_controller}:6080/vnc_auto.html",
    }
  }


