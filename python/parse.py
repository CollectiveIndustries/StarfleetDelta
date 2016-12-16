#!/usr/bin/python
#
# Title: parse.py
#
# Purpose: Takes text documents from doc folder and parses them for upload to the correct classes DB.
#
# Copyright (C) Andrew Malone 2016

# Imports for commonly used function

import glob
import re
import os
import subprocess
import getpass
import ConfigParser
from module import config, function
import MySQLdb
import warnings

######## variable init #######


##	# Global Variables #	##

warnings.filterwarnings('error',category=MySQLdb.Warning)

# Regular Expression Groups #

DESC = "\A<DESC:.*>"

	## UUID number matching Regular Expression to find any UUIDs in the text with an ASSET TYPE. ##
TEXTURE_TAG = "\A<TEXTURE:[0-9a-f]{8}-([0-9a-f]{4}-){3}[0-9a-f]{12}>"
SOUND_TAG = "\A<SOUND:[0-9a-f]{8}-([0-9a-f]{4}-){3}[0-9a-f]{12}>"

# SQL section #
INSERT_CLASS = "INSERT INTO `courses` (`AutherID`,`Class Name`, `Class Description`) VALUES ('%s','%s','%s')"
LOOKUP_AUTHER = "SELECT `ID` FROM `accounts` WHERE `username` = '%s'"

ASSET_TYPE = "SELECT type.`atid` FROM `asset_types` type WHERE type.`type` = '%s'"
INSERT_ASSET = "INSERT IGNORE INTO `assets` (`type`,`uuid`,`name`) VALUES ('%s','%s','%s')"

CLASS_ID = "SELECT `ClassID` FROM `courses` WHERE `Class Name` = '%s'"
INSERT_LINE = "INSERT INTO `curriculum` (`classID`,`lineNumber`,`displayText`) VALUES ('%s','%s','%s')"

ASSET_ID = "SELECT a.`aid` FROM `assets` a WHERE a.`uuid`='%s'"
INSERT_ASSET_LINE = "INSERT INTO `curriculum` (`classID`,`asset_id`,`lineNumber`) VALUES ('%s','%s','%s')"

TABLES = ["assets","courses","curriculum","exams","gradebook","scores"]

CONVERT = "ALTER TABLE `curriculum` COLLATE='latin1_swedish_ci', CONVERT TO CHARSET latin1"

# Class definitions #

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

## Function Delerations ##

# run a Commit
def sql(statement):
	try:
		num_rows = cursor.execute(statement)
#		if num_rows == 0:
#			print(color.HEADER)
#			print("SQL %s: %s" % (num_rows,statement))
#			print(color.END)
	except Warning as w:
		print(color.WARNING+"\nWARNING: "+statement+"\n"+format(w)+color.END)
	except Exception as e:
		print(color.FAIL+"\nERROR: "+statement+"\n"+format(e)+color.END)
		exit(1)
	db.commit()

# Run a Fetch
def fetch(statement):
	try:
		num_rows = cursor.execute(statement)
#		if num_rows == 0:
#                        print(color.HEADER)
#                        print("FETCH %s: %s" % (num_rows,statement))
#                        print(color.END)
        except Warning as w:
                print(color.WARNING+"\nWARNING: "+statement+"\n"+format(w)+color.END)
        except Exeception as e:
                print(color.FAIL+"\nERROR: "+statement+"\n"+format(e)+color.END)
        db.commit()
	return cursor.fetchone()


# precompile all the RegEx
desc = re.compile(DESC)
texture = re.compile(TEXTURE_TAG)
sound = re.compile(SOUND_TAG)



### Main Script ###

subprocess.call('clear')
print "Welcome: " + getpass.getuser()
print "Starfleet Delta Notecard Parser Copyright (C) 2016 Andrew Malone Collective Industries\n\n"
print os.getcwd()
db = function.MySQL_init()

cursor = db.cursor()

data = fetch("SELECT VERSION()")
print("Database version: %s " % data)
print("Database configuration settings are correct\n\n")

print(color.HEADER+"Attempting to clean system........"+color.END)
sql("SET FOREIGN_KEY_CHECKS = 0")
for t in TABLES:
	print(color.WARNING+t+color.END)
	sql("TRUNCATE %s" % (t))
	sql("ALTER TABLE %s AUTO_INCREMENT = 1" % (t))

sql("SET FOREIGN_KEY_CHECKS = 1")
print(color.OKGREEN+"OK"+color.END)

# get a list of files and save to list called Classes
classes = [file for file in glob.glob("../doc/sdq_classes/*.txt")]

# open each file and prepare for reading.
for c in classes:
	file = c.split("/")[-1]  # grab the actual file name with out the path
	row = file.split(".")[0] # chop the extension off
	name = row.split("_")[0] # split file name into a list using "_" as a seperator
	try: # try to ressemble the Author name if it failes its probably unnamed
		author = row.split("_")[1]+" "+row.split("_")[2]
	except Exception: # If name is was not found on the file name throw a warning and add "Unknown Author"
		print(color.WARNING+"WARNING: "+c+" --> Unknown Author"+color.END)
		author = "Unknown Author"

	print(color.OKGREEN+"CLASS: "+name+"\nAUTHOR: "+author+color.END)
	with open(c,'rb') as file:
		line_number = 1 # Reset the line counter on each file open
		for line in file: # Read through the file line by line
			line = line.replace("","")
			line = line.replace("","")
			if desc.match(line) is not None:
				txt = line.replace("<DESC:", "")
				txt = txt.replace(">","")
				AID = fetch(LOOKUP_AUTHER %(author))[0]
				sql(INSERT_CLASS % (AID,name,txt.strip("\n")))
				print(color.OKGREEN+txt+color.END)
				CID = fetch(CLASS_ID % (name))[0] # Grab the Class ID number for the class we just added

			elif sound.match(line) is not None:
#				print("%sLINE: %s = %s%s"%(color.OKBLUE,line_number,line.strip('\n'),color.END))
				uuid = line.replace("<SOUND:","")
				uuid = uuid.replace(">","")
				type = fetch(ASSET_TYPE % ('SOUND'))[0]
				sql(INSERT_ASSET % (type,uuid.strip("\n"),'SOUND'))
				asset_id = fetch(ASSET_ID % (uuid.strip("\n")))[0]
                                sql(INSERT_ASSET_LINE % (CID,asset_id,line_number))
#				if line_number == 3:
#					print(line)
#					print(INSERT_ASSET_LINE % (CID,asset_id,line_number))
				line_number += 1

			elif texture.match(line) is not None:
#				print("%sLINE: %s = %s%s"%(color.OKBLUE,line_number,line.strip('\n'),color.END))
				uuid = line.replace("<TEXTURE:","")
                                uuid = uuid.replace(">","")
				type = fetch(ASSET_TYPE % ('TEXTURE'))[0]
				sql(INSERT_ASSET % (type,uuid.strip("\n"),'TEXTURE')) # SOUND
				asset_id = fetch(ASSET_ID % (uuid.strip("\n")))[0]
				sql(INSERT_ASSET_LINE % (CID,asset_id,line_number))
#				if line_number == 3:
#					print(line)
 #                                       print(INSERT_ASSET_LINE % (CID,asset_id,line_number))
				line_number += 1 # Line Index + 1 IF its not the DESC line

			else:
				sql(INSERT_LINE % (CID,line_number,MySQLdb.escape_string(line.strip("\n"))))
#				if line_number == 3:
#					print(line)
 #                                       print(INSERT_LINE % (CID,line_number,MySQLdb.escape_string(line.strip("\n"))))
				line_number += 1
sql(CONVERT)
db.commit()
#		print(color.HEADER+"TOTAL LINES"+color.END)
#		print(line_number) # End of class
