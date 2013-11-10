cubbystack_config { '/etc/keystone/keystone.conf: DEFAULT/verbose':
  value => true,
}
cubbystack_config { '/etc/keystone/keystone.conf: filter:debug/paste.filter_factory':
  value => '--keystone.common.wsgi:Debug.factory',
}
