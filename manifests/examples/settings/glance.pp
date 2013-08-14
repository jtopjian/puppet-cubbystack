class cubbystack::examples::settings::glance {
  $glance_settings = {
    api                                      => {
      'DEFAULT/use_syslog'                   => true,
      'DEFAULT/syslog_log_facility'          => 'LOG_LOCAL1',
      'DEFAULT/log_file'                     => '/var/log/glance/api.log',
      'DEFAULT/backlog'                      => 4096,
      'DEFAULT/workers'                      => $::processorcount,
      'DEFAULT/default_store'                => 'file',
      'DEFAULT/filesystem_store_datadir'     => '/var/lib/glance/images',
      'DEFAULT/image_cache_dir'              => '/var/lib/glance/image-cache/',
      'DEFAULT/sql_connection'               => 'mysql://glance:password@localhost/glance',
      'DEFAULT/sql_idle_timeout'             => 3600,
      'DEFAULT/api_limit_max'                => 1000,
      'keystone_authtoken/auth_host'         => 'localhost',
      'keystone_authtoken/auth_port'         => '35357',
      'keystone_authtoken/auth_protocol'     => 'http',
      'keystone_authtoken/admin_tenant_name' => 'services',
      'keystone_authtoken/admin_user'        => 'glance',
      'keystone_authtoken/admin_password'    => 'password',
      'paste_deploy/flavor'                  => 'keystone+cachemanagement',
    },
    cache => {
      'DEFAULT/use_syslog'                   => true,
      'DEFAULT/syslog_log_facility'          => 'LOG_LOCAL1',
      'DEFAULT/log_file'                     => '/var/log/glance/cache.log',
    },
    registry => {
      'DEFAULT/use_syslog'                   => true,
      'DEFAULT/syslog_log_facility'          => 'LOG_LOCAL1',
      'DEFAULT/sql_connection'               => 'mysql://glance:password@localhost/glance',
      'DEFAULT/log_file'                     => '/var/log/glance/registry.log',
      'DEFAULT/backlog'                      => 4096,
      'DEFAULT/limit_param_default'          => 25,
      'keystone_authtoken/auth_host'         => 'localhost',
      'keystone_authtoken/auth_port'         => '35357',
      'keystone_authtoken/auth_protocol'     => 'http',
      'keystone_authtoken/admin_tenant_name' => 'services',
      'keystone_authtoken/admin_user'        => 'glance',
      'keystone_authtoken/admin_password'    => 'password',
      'paste_deploy/flavor'                  => 'keystone',
    }
  }
}
