#!/usr/bin/python
##################################################################################################
#
# Copyright (C) Andrew Malone, Collective Industries 2016
#
# AUTHOR: Andrew Malone
#
# TITLE: config
#
# PURPOSE: Configuration import
#
#
##################################################################################################

import ConfigParser
import os

conf = ConfigParser.ConfigParser()
conf.read(os.path.abspath("config.d/ufgq.conf"))
conf.sections()

## Config Parse Helper ##

def ConfigSectionMap(section):
    dict1 = {}
    options = conf.options(section)
    for option in options:
        try:
            dict1[option] = conf.get(section, option)
            if dict1[option] == -1:
                print("Skipping: %s %s" % (section,option))
        except:
            print("exception on %s %s!" % (section,option))
            dict1[option] = None
    return dict1



# Set up config values
# TODO If these are blank/invalid we will ask the user to fix them on the fly

# MYSQL server config
_IN_MYSQL_HOST_ = ConfigSectionMap("DB")['host']
_IN_MYSQL_USR_ = ConfigSectionMap("DB")['user']
_IN_MYSQL_PASS_ = ConfigSectionMap("DB")['password']
_IN_MYSQL_DB_ = ConfigSectionMap("DB")['database']
_IN_MYSQL_FILE_ = ConfigSectionMap("DB")['sqlConfigFile']

# Web Site config
_IN_PHP_CONFIG_ = ConfigSectionMap("WEB")['phpConfigFile']
