#!/bin/bash

cd /etc/puppet/modules
git clone https://github.com/puppetlabs/puppetlabs-stdlib stdlib
git clone https://github.com/stackforge/puppet-nova nova
git clone https://github.com/stackforge/puppet-keystone keystone
git clone https://github.com/puppetlabs/puppetlabs-mysql mysql
git clone https://github.com/puppetlabs/puppetlabs-inifile inifile
git clone https://github.com/saz/puppet-ssh ssh
git clone https://github.com/puppetlabs/puppetlabs-rsync rsync
git clone https://github.com/saz/puppet-memcached memcached
git clone https://github.com/puppetlabs/puppetlabs-rabbitmq rabbitmq
cd /etc/puppet/modules/rabbitmq
git checkout tags/2.1.0
