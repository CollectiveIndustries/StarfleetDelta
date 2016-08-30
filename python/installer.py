#!/usr/bin/python
#
# Title: install.py
#
# Purpose: Installs UFGQ Webpage and Database.
#
# Copyright (C) Andrew Malone 2015

import MySQLdb
import os
from subprocess import call
import os
import subprocess
import sys
import getpass
import shlex
from time import sleep
import ConfigParser
from module import config


subprocess.call('clear')
print "Welcome: " + getpass.getuser()
print "UFGQ Installer Copyright (C) 2016 Andrew Malone Collective Industries"
print "Resuming in 5 seconds"
sleep(5)

db = MySQLdb.connect(config._IN_MYSQL_HOST_,config._IN_MYSQL_USR_,config._IN_MYSQL_PASS_,config._IN_MYSQL_DB_)
cursor = db.cursor()

cursor.execute("SELECT VERSION()")
data = cursor.fetchone()
print "Database version: %s " % data
sleep(5)
db.close()
