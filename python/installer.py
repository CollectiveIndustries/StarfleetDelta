#!/usr/bin/python
#
# Title: install.py
#
# Purpose: Installs UFGQ Webpage and Database.
#
# Copyright (C) Andrew Malone 2015

import MySQLdb
from subprocess import call, Popen, PIPE
import os
import subprocess
import sys
import getpass
import shlex
from time import sleep
import ConfigParser
from module import config, functions

######## variable init #######
username = None
password = None

# Insert statement for creating a new admin user on first install.
sql = "INSERT INTO `academy`.`accounts` (`username`, `password`, `db_privlage_level`) VALUES (%s, SHA2(%s, 512), 3)"
sql_data = []


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

# select statment used for login page.
# "SELECT id FROM WHERE username = USER and password = PASSWORD"
# password SHA2('password', 512)


while ((username is None) or (username == '')):
                username = raw_input('New Administrator account for the webpage (cannot be left blank): ')
while ((password is None) or (password == '')):
                password = raw_input('Password for New administrator (cannot be left blank): ')

sql_data = [username, password]

# Execute sql statement
cursor.execute(sql,sql_data)

# Commit changes
db.commit()

# Close DB Connection
db.close()
