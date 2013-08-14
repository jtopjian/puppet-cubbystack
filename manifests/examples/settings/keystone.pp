class cubbystack::examples::settings::keystone {
  $keystone_settings = {
    'DEFAULT/admin_token'                             => '12345',
    'DEFAULT/verbose'                                 => true,
    'DEFAULT/debug'                                   => true,
    'DEFAULT/use_syslog'                              => true,
    'DEFAULT/syslog_log_facility'                     => 'LOG_LOCAL2',
    'sql/connection'                                  => 'mysql://keystone:password@localhost/keystone',
    'catalog/driver'                                  => 'keystone.catalog.backends.templated.TemplatedCatalog',
    'catalog/template_file'                           => '/etc/keystone/default_catalog.templates',
    'token/driver'                                    => 'keystone.token.backends.memcache.Token',
    'policy/driver'                                   => 'keystone.policy.backends.rules.Policy',
    'ec2/driver'                                      => 'keystone.contrib.ec2.backends.sql.Ec2',
    'signing/token_format'                            => 'UUID',
  }
}
