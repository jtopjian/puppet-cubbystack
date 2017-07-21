#! /usr/bin/env python
# -*- coding: utf-8 -*-

# This imports publicsuffix.org via the TLD API instead of designate-manage tld import which can use a .csv file.
# Does not handle deletions but will import additions if downloaded later.

import logging
import requests
import os
import time
import datetime

from designateclient.v2 import client
from designateclient import exceptions
from designateclient import shell

from keystoneclient.auth.identity import generic
from keystoneclient import session as keystone_session


# Authenticate

auth = generic.Password(
		auth_url=shell.env('OS_AUTH_URL'),
		username=shell.env('OS_USERNAME'),
		password=shell.env('OS_PASSWORD'),
		tenant_name=shell.env('OS_TENANT_NAME'))	
session = keystone_session.Session(auth=auth)
client = client.Client(session=session)


# Check if the public_suffix_list is newer than the last change according to the atom feed?
r = requests.head("https://publicsuffix.org/list/public_suffix_list.dat")
print ""
print ""
print r.headers['Last-Modified']
list_mod_date = datetime.datetime.strptime(r.headers['Last-Modified'], "%a, %d %b %Y %H:%M:%S %Z")

r.close

try:
	local_date = datetime.datetime.fromtimestamp(os.path.getmtime("public_suffix_list.dat"))
except:
	local_date = datetime.datetime.fromtimestamp(0)

print list_mod_date
print local_date

if local_date > list_mod_date:
	print "Already have latest version of the list. Assuming it's imported and exitting"
	#exit(0)
else:
	print "Need to get new version"
	list = requests.get("https://publicsuffix.org/list/public_suffix_list.dat")

	if list.status_code == 200:
		with open("public_suffix_list.dat", "w") as file:
			list.raw.decode_content = True
			for chunk in list:
				file.write(chunk)	

with open('public_suffix_list.dat', "r") as list_file:
	for i, line in enumerate(list_file):
		entry = line.strip()
		if not entry.startswith("/") and len(entry) > 0:
			# Fix *. entries (eg. *.bd) to be Designate compliant
			if line.startswith("*."):
				line = line[2:]
			tld = line.rstrip()
			try:
				client.tlds.create(name=tld,
					description="TLD Source: publicsuffix.org")
			except exceptions.BadRequest:
				print "BadRequest (Likely unicode): %s" % (tld)
			except exceptions.Conflict:
				pass
			except exceptions as e:
				print "Exception: %s %s" % (e, tld)


# DELETE EM ALL
#tlds = client.tlds.list()
i = 0
while len(tlds) > 0:
	for tld in tlds:
		#client.tlds.delete(tld['id'])
		print "%s %s %s" % (tld['id'], tld['name'], tld['created_at'])
		i = i + 1
	tlds = client.tlds.list()

tlds = client.tlds.list()
for tld in tlds:
	print "%s %s %s" % (tld['id'], tld['name'], tld['created_at'])
