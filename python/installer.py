#!/usr/bin/python
#
# Title: install.py
#
# Purpose: Installs Starfleet Delta Webpage and Database.
#
# Copyright (C) Andrew Malone 2015

import MySQLdb
from subprocess import call, Popen, PIPE
import os
import shutil # File manipulation
import subprocess
import sys
import getpass
import shlex
from time import sleep
import ConfigParser
from module import config, function

######## variable init #######
username = None
password = None

# Insert statement for creating a new admin user on first install.
sql = "INSERT INTO `accounts` (`username`, `password`, `db_privlage_level`) VALUES (%s, SHA2(%s, 512), 3)"

### Main Script ###

subprocess.call('clear')
print "Welcome: " + getpass.getuser()
print "Starfleet Delta Installer Copyright (C) 2016 Andrew Malone - Collective Industries (tm)\n\n"

db = function.MySQL_init()
cursor = db.cursor()

cursor.execute("SELECT VERSION()")
data = cursor.fetchone()
print "Database version: %s " % data
print "Database configuration settings are correct\n\n"
print "Uploading "+config._IN_MYSQL_FILE_+" to database.......Please standby this could take a long time depending on file size"
sleep(2)

# Open the file ReadOnly and stream it to MySQL's Standard In. Redirect Standard Out/Error
with open(config._IN_MYSQL_FILE_, 'r') as f:
       command = ['mysql', '-u%s' % config._IN_MYSQL_USR_, '-p%s' % config._IN_MYSQL_PASS_, '-h%s' % config._IN_MYSQL_HOST_,'--port=%s' % config._IN_MYSQL_PORT_]
       proc = Popen(command, stdin = f)
       stdout, stderr = proc.communicate()

print "Upload finished."

# get webadmin username and password
while ((username is None) or (username == '')):
                username = raw_input('New Administrator account for the webpage (cannot be left blank): ')
while ((password is None) or (password == '')):
		print "Password for New administrator (cannot be left blank)"
		password = getpass.getpass()

# Execute the SQL Statement on the server
cursor.execute(sql,(username,password) )

# Commit changes
db.commit()

# Close DB Connection
db.close()


# Write the PHP Configuration file with all the database settings we just set up.
_FILE_ = open(config._IN_PHP_CONFIG_, 'w')

_FILE_.write("<?php\n")
_FILE_.write("\t$DB_SERVER = '%s';\n" % (config._IN_MYSQL_HOST_))
_FILE_.write("\t$DB_USERNAME = '%s';\n" % (config._IN_MYSQL_USR_))
_FILE_.write("\t$DB_PASSWORD = '%s';\n" % (config._IN_MYSQL_PASS_))
_FILE_.write("\t$DB_DATABASE = '%s';\n" % (config._IN_MYSQL_DB_))
_FILE_.write("\t$DB_PORT = '%s';\n" % (config._IN_MYSQL_PORT_))
_FILE_.write("\t$db = mysqli_connect($DB_SERVER, $DB_USERNAME, $DB_PASSWORD,$DB_DATABASE, $DB_PORT);\n")
_FILE_.write("\tif(mysqli_connect_errno()) { die('Databse Connection Error - ' . mysqli_connect_error()); }\n")
_FILE_.write("?>\n")

_FILE_.close()

# File manipulators to move webpage
function.mv(config._PHP_REPO_,config._WEB_ROOT_)

# Install Default data to the database from here.
