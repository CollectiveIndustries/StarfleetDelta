#!/usr/bin/python

## hopefully we can avoide disaster if we dont import this in a main program
try:
  config
except NameError:
  import config
import MySQLdb


## MySQL init function added an error handler + a config data setting dump should be able to use this for all python database connections
def MySQL_init():
    ## Set up the Connection using config.d/NAME.conf returns a standard DB Object
    try:
        db = MySQLdb.connect(config._IN_MYSQL_HOST_,config._IN_MYSQL_USR_,config._IN_MYSQL_PASS_,config._IN_MYSQL_DB_)
        return db
    except MySQLdb.Error:
        print "There was a problem in connecting to the database."
        print "Please ensure that the database exists on the target system, and that you have configured the settings properly in config/ufgq.conf"
        print "Config DUMP:"
        print "HOST: %s\nUSER: %s\nPASS: %s\nDATABASE: %s" %(config._IN_MYSQL_HOST_,config._IN_MYSQL_USR_,config._IN_MYSQL_PASS_,config._IN_MYSQL_DB_)
	## TODO instead of just exiting the installer lets actualy prompt the user to fix it and then try again
        exit(4) ## Unclean exit with out Traceback we dont need to traceback because we know its a bad config so prompt the user to fix it
    except MySQLdb.Warning:
        pass
