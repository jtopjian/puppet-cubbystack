class cubbystack::examples::settings::cinder_controller.pp
  $cinder_settings = {
    paste => {
      'filter:authtoken/auth_host'         => 'localhost',
      'filter:authtoken/auth_port'         => '35357',
      'filter:authtoken/auth_protocol'     => 'http',
      'filter:authtoken/admin_tenant_name' => 'services',
      'filter:authtoken/admin_user'        => 'nova',
      'filter:authtoken/admin_password'    => 'password',
    },
    conf => {
      'DEFAULT/rootwrap_config'      => '/etc/cinder/rootwrap.conf',
      'DEFAULT/api_paste_confg'      => '/etc/cinder/api-paste.ini',
      'DEFAULT/iscsi_helper'         => 'tgtadm',
      'DEFAULT/volume_name_template' => 'volume-%s',
      'DEFAULT/volume_group'         => 'cinder-volumes',
      'DEFAULT/verbose'              => true,
      'DEFAULT/auth_strategy'        => 'keystone',
      'DEFAULT/state_path'           => '/var/lib/cinder',
      'DEFAULT/volumes_dir'          => '/var/lib/cinder/volumes',
      'DEFAULT/sql_connection'       => 'mysql://cinder:password@localhost/cinder',
      'DEFAULT/rabbit_host'          => 'localhost',
      'DEFAULT/rabbit_userid'        => 'nova',
      'DEFAULT/rabbit_password'      => 'password',
      'DEFAULT/use_syslog'           => true,
      'DEFAULT/api_paste_config'     => '/etc/cinder/api-paste.ini',
      'DEFAULT/syslog_log_facility'  => 'LOG_LOCAL3',
      'DEFAULT/notification_topics'  => 'monitor',
      'DEFAULT/control_exchange'     => 'nova',
      'DEFAULT/glance_host'          => 'localhost',
      'DEFAULT/volume_driver'        => 'cinder.volume.nfs.NfsDriver',
      'DEFAULT/nfs_shares_config'    => '/etc/cinder/shares.txt',
    }
  }
}
