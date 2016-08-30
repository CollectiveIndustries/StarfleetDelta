#!/usr/bin/python
##################################################################################################
#
# Copyright (C) 2016 Andrew Malone
#
# AUTHOR: Andrew Malone
#
# TITLE: config
#
# PURPOSE: configuration importer
#
#
##################################################################################################

import ConfigParser
import os

ice = ConfigParser.ConfigParser()
ice.read(os.path.abspath("config.d/ufgq.conf"))
ice.sections()

## Config Parse Helper ##

def ConfigSectionMap(section):
    dict1 = {}
    options = ice.options(section)
    for option in options:
        try:
            dict1[option] = ice.get(section, option)
            if dict1[option] == -1:
                print("Skipping: %s %s" % (section,option))
        except:
            print("exception on %s %s!" % (section,option))
            dict1[option] = None
    return dict1



# Set up config values
_IN_MYSQL_HOST_ = ConfigSectionMap("DB")['host']
_IN_MYSQL_USR_ = ConfigSectionMap("DB")['user']
_IN_MYSQL_PASS_ = ConfigSectionMap("DB")['password']
_IN_MYSQL_DB_ = ConfigSectionMap("DB")['database']
