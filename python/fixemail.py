#!/usr/bin/python
#
# Title: fixemail.py
#
# Purpose: Takes the users in the accounts list and pulls there Username stripts all the whitespace and adds @ufgq.co and adds back to the email field on the database for email accounts.
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

# Insert statement for creating a new admin user on first install.
select = "SELECT id, CONCAT(REPLACE(`username`,' ',''),'@StarfleetDelta.com') AS Mail FROM `accounts`"
update = "UPDATE `accounts` SET `email`='%s' WHERE `ID`=%s"

### Main Script ###

subprocess.call('clear')
print "Welcome: " + getpass.getuser()
print "Starfleet Delta Installer Copyright (C) 2016 Andrew Malone Collective Industries\n\n"

db = function.MySQL_init()

cursor = db.cursor()
curupdate = db.cursor()

cursor.execute("SELECT VERSION()")
data = cursor.fetchone()
print "Database version: %s " % data
print "Database configuration settings are correct\n\n"
sleep(2)

cursor.execute(select)
db.commit()
results = cursor.fetchall()

widths = []
columns = []
tavnit = '|'
separator = '+'

for cd in cursor.description:
    widths.append(max(cd[2], len(cd[0])))
    columns.append(cd[0])

for w in widths:
    tavnit += " %-"+"%ss |" % (w,)
    separator += '-'*w + '--+'

print(separator)
print(tavnit % tuple(columns))
print(separator)
for row in results:
    print(tavnit % row)
    curupdate.execute(update % (row[1],row[0]))
print(separator)

db.commit()
