#!/usr/bin/python
#
# Title: install.py
#
# Purpose: Installs UFGQ Webpage and Database.
#
# Copyright (C) Andrew Malone 2015

import MySQLdb
import os
from subprocess import call, Popen, PIPE
import os
import subprocess
import sys
import getpass
import shlex
from time import sleep
import ConfigParser
from module import config, functions

subprocess.call('clear')
print "Welcome: " + getpass.getuser()
print "UFGQ Installer Copyright (C) 2016 Andrew Malone Collective Industries"
print "Resuming in 5 seconds"
sleep(5)

db = functions.MySQL_init()
cursor = db.cursor()

cursor.execute("SELECT VERSION()")
data = cursor.fetchone()
print "Database version: %s " % data
print "Database configuration settings are correct"
sleep(5)
db.close()

print "Uploading "+config._IN_MYSQL_FILE_+" to database.......Please standby this could take a long time depending on file size"

# Open the file ReadOnly and stream it to MySQL's Standard In. Redirect Standard Out/Error
with open(config._IN_MYSQL_FILE_, 'r') as f:
       command = ['mysql', '-u%s' % config._IN_MYSQL_USR_, '-p%s' % config._IN_MYSQL_PASS_, '-h%s' % config._IN_MYSQL_HOST_, config._IN_MYSQL_DB_]
       proc = Popen(command, stdin = f)
       stdout, stderr = proc.communicate()

print "Upload finished."

# TODO add in file manipulators to move webpage
# TODO set up variables for admin account
# TODO walk the user through account creation to build the web admin
