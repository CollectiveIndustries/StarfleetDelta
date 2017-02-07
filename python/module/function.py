#!/usr/bin/python

## Hopefully we can avoid disaster if we dont import this in a main program
try:
  config
except NameError:
  import config

import MySQLdb
import os, shutil
from getpass import getpass
# Text output color definitions
class color:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    END = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'

## MySQL init function added an error handler + a config data setting dump should be able to use this for all python database connections
def MySQL_init():
	while True:

    ## Set up the Connection using config.d/NAME.conf returns a standard DB Object
		try:
			db = MySQLdb.connect(host=config._IN_MYSQL_HOST_,user=config._IN_MYSQL_USR_,passwd=config._IN_MYSQL_PASS_,db=config._IN_MYSQL_DB_)
			# TODO add a config writter to save values so any time we run the program we dont have to set values again.
			return db

		except MySQLdb.Error:
			print "There was a problem in connecting to the database."
			print "Config DUMP:"
			print "HOST: %s\nUSER: %s\nPASS: %s\nDATABASE: %s" %(config._IN_MYSQL_HOST_,config._IN_MYSQL_USR_,config._IN_MYSQL_PASS_,config._IN_MYSQL_DB_)
			print "Please Enter the correct login credentials below.\nRequired items are marked in "+color.FAIL+"RED"+color.END+" Any default values will be marked with []"

			## > fix values here < ##

			config._IN_MYSQL_HOST_ = None
			config._IN_MYSQL_USR_ = None
			config._IN_MYSQL_PASS_ = None
			config._IN_MYSQL_DB_ = None

			# After restting variables to None we need to prompt the user for each one and try again.

			while ((config._IN_MYSQL_HOST_ is None) or (config._IN_MYSQL_HOST_=='')):
				config._IN_MYSQL_HOST_ = raw_input(color.FAIL+"Mysql Server Host (example.com) []: "+color.END)
			while ((config._IN_MYSQL_DB_ is None) or (config._IN_MYSQL_DB_ == '')):
				config._IN_MYSQL_DB_ = raw_input(color.FAIL+"Name of Database []: "+color.END)
			while ((config._IN_MYSQL_USR_ is None) or (config._IN_MYSQL_USR_ == '')):
				config._IN_MYSQL_USR_ = raw_input(color.FAIL+"Username []: "+color.END)
			while ((config._IN_MYSQL_PASS_ is None) or (config._IN_MYSQL_PASS_ == '')):
				config._IN_MYSQL_PASS_ = getpass(color.FAIL+"Password []: "+color.END)
			pass
		except MySQLdb.Warning:
			break


# make sure that these directories exist
def mv(dir_src,dir_dst):
	for file in os.listdir(dir_src):
		print "Installing: %s" % file
		src_file = os.path.join(dir_src, file)
		dst_file = os.path.join(dir_dst, file)
		shutil.copyfile(src_file, dst_file)
