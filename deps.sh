#!/bin/bash
#
# This script will download the various required modules

cd /etc/puppet/modules

# PuppetLabs stdlib
git clone https://github.com/puppetlabs/puppetlabs-stdlib stdlib

# apt
git clone https://github.com/puppetlabs/puppetlabs-apt apt

# apache
git clone https://github.com/puppetlabs/puppetlabs-apache apache

# nova - temporary
git clone https://github.com/stackforge/puppet-nova nova

# keystone - used for keystone_* types
git clone https://github.com/stackforge/puppet-keystone keystone

# mysql
git clone https://github.com/puppetlabs/puppetlabs-mysql mysql

# inifile
git clone https://github.com/puppetlabs/puppetlabs-inifile inifile

# ssh - used for swift
git clone https://github.com/saz/puppet-ssh ssh

# rsync - used for swift
git clone https://github.com/puppetlabs/puppetlabs-rsync rsync

# memcached
git clone https://github.com/saz/puppet-memcached memcached

# rabbitmq
git clone https://github.com/puppetlabs/puppetlabs-rabbitmq rabbitmq
cd /etc/puppet/modules/rabbitmq
git checkout origin/2.x
