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

EXAMS_LOC =   "../doc/sdq_exams/*.txt"
CLASSES_LOC = "../doc/sdq_classes/*.txt"

# Regular Expression Groups #

	## Description Tag for Classes ##
DESC = "\A<DESC:.*>"

	## UUID for locating ASSET TYPES ##
TEXTURE_TAG = "\A<TEXTURE:[0-9a-f]{8}-([0-9a-f]{4}-){3}[0-9a-f]{12}>"
SOUND_TAG = "\A<SOUND:[0-9a-f]{8}-([0-9a-f]{4}-){3}[0-9a-f]{12}>"

	## Exams Regex groups ##
OPTION_TAG = "\A[A-D]:.*"
QUESTION_TAG = "\A[0-9]{1,2}\.\s.*"
ANSWER_TAG = "\A[A-D]$"

# SQL section #

	## CLASSES ##
INSERT_CLASS = "INSERT INTO `courses` (`DivID`, `AutherID`, `Class Name`, `Class Description`) VALUES ('%s','%s','%s','%s')"
LOOKUP_AUTHER = "SELECT `ID` FROM `accounts` WHERE `username` = '%s'"

ASSET_TYPE = "SELECT type.`atid` FROM `asset_types` type WHERE type.`type` = '%s'"
INSERT_ASSET = "INSERT IGNORE INTO `assets` (`type`,`uuid`,`name`) VALUES ('%s','%s','%s')"

CLASS_ID = "SELECT `ClassID` FROM `courses` WHERE `Class Name` = '%s'"
INSERT_LINE = "INSERT INTO `curriculum` (`classID`,`lineNumber`,`displayText`) VALUES ('%s','%s','%s')"

ASSET_ID = "SELECT a.`aid` FROM `assets` a WHERE a.`uuid`='%s'"
INSERT_ASSET_LINE = "INSERT INTO `curriculum` (`classID`,`asset_id`,`lineNumber`) VALUES ('%s','%s','%s')"

FILE_NAME = "SELECT `did`, `dname` FROM `divisions` WHERE FileNamePrefix = '%s'"

	## EXAMS ##
INSERT_EXAM_LINE = "INSERT INTO `exams` (`course_id`, `question_number`, `question`, `a`, `b`, `c`, `d`, `answer`) VALUES ('%s','%s','%s','%s','%s','%s','%s','%s')"


	## Tables we are going to need to TRUNCATE ##
#TABLES = ["assets","courses","curriculum","exams","gradebook","scores"]

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

	## run a Commit ##
def sql(statement):
	try:
		num_rows = cursor.execute(statement)
	except Warning as w:
		print(color.WARNING+"\nWARNING: "+statement+"\n"+format(w)+color.END)
	except Exception as e:
		print(color.FAIL+"\nERROR: "+statement+"\n"+format(e)+color.END)
		exit(1)
	db.commit()

def InsertExam(statement):
	try:
		num_rows = cursor.execute(statement)
	except Warning as w:
		print(color.WARNING+"\nWARNING: "+statement+"\n"+format(w)+color.END)
	except MySQLdb.IntegrityError as I:
		#print(color.FAIL+"\nIntegrityError: "+statement+"\n"+format(I)+color.END)
		pass
	db.commit()

	## Run a Fetch ##
def fetch(statement):
	try:
		num_rows = cursor.execute(statement)
        except Warning as w:
                print(color.WARNING+"\nWARNING: "+statement+"\n"+format(w)+color.END)
        except Exeception as e:
                print(color.FAIL+"\nERROR: "+statement+"\n"+format(e)+color.END)
        db.commit()
	return cursor.fetchone()


# Precompile all the RegEx
desc = re.compile(DESC)
texture = re.compile(TEXTURE_TAG)
sound = re.compile(SOUND_TAG)
option = re.compile(OPTION_TAG)
question = re.compile(QUESTION_TAG)
answer = re.compile(ANSWER_TAG)

### Main Script ###

subprocess.call('clear')
print "Welcome: " + getpass.getuser()
print "Starfleet Delta Notecard Parser Copyright (C) 2016 Andrew Malone Collective Industries\n\n"
print os.getcwd()
db = function.MySQL_init()

cursor = db.cursor()

data = fetch("SELECT VERSION()")
print("Database version: %s" % data)
print("Database configuration settings are correct\n\n")

# Glob all the Classes into a list
classes = [file for file in glob.glob(CLASSES_LOC)]

# open each file and prepare for reading.
for c in classes:
	file = c.split("/")[-1]  # grab the actual file name with out the path
	row = file.split(".")[0] # chop the extension off
	name = row.split("_")[0] # split file name into a list using "_" as a seperator

	if fetch(CLASS_ID % (name)) is None: #only continue if the Database has NO RECORD matching NAME
		div = fetch(FILE_NAME % (name.split("-")[0])) # grab the File name Prefix and crossrefrence with the Divison name on file
		try: # try to ressemble the Author name if it failes its probably unnamed
			author = row.split("_")[1]+" "+row.split("_")[2]
		except Exception: # If name is was not found on the file name throw a warning and add "Unknown Author"
			print(color.WARNING+"WARNING: "+c+" --> Unknown Author"+color.END)
			author = "Unknown Author"
		print(color.HEADER+"DIVISION: "+div[1].rstrip()+color.END)
		print(color.OKGREEN+"\nCLASS: "+name+"\nAUTHOR: "+author+color.END)
		with open(c,'rb') as file:
			line_number = 1 # Reset the line counter on each file open
			for line in file: # Read through the file line by line
				if desc.match(line) is not None:
					txt = line.replace("<DESC:", "")
					txt = txt.replace(">","")
					AID = fetch(LOOKUP_AUTHER %(author))[0]
					sql(INSERT_CLASS % (div[0],AID,name,txt.strip("\n")))
					print(color.OKGREEN+txt+color.END)
					CID = fetch(CLASS_ID % (name))[0] # Grab the Class ID number for the class we just added

				elif sound.match(line) is not None:
					uuid = line.replace("<SOUND:","")
					uuid = uuid.replace(">","")
					type = fetch(ASSET_TYPE % ('SOUND'))[0]
					sql(INSERT_ASSET % (type,uuid.strip("\n"),'SOUND'))
					asset_id = fetch(ASSET_ID % (uuid.strip("\n")))[0]
                                	sql(INSERT_ASSET_LINE % (CID,asset_id,line_number))
					line_number += 1

				elif texture.match(line) is not None:
					uuid = line.replace("<TEXTURE:","")
                                	uuid = uuid.replace(">","")
					type = fetch(ASSET_TYPE % ('TEXTURE'))[0]
					sql(INSERT_ASSET % (type,uuid.strip("\n"),'TEXTURE')) # SOUND
					asset_id = fetch(ASSET_ID % (uuid.strip("\n")))[0]
					sql(INSERT_ASSET_LINE % (CID,asset_id,line_number))
					line_number += 1 # Line Index + 1 IF its not the DESC line

				else:
					sql(INSERT_LINE % (CID,line_number,MySQLdb.escape_string(line.strip("\n"))))
					line_number += 1
	else:
		print(color.WARNING+"Class "+name+" already on file....Skipping")

db.commit()

# START Exams Parsing #

# Glob all the Exams into a list
exams = [file for file in glob.glob(EXAMS_LOC)]
for e in exams:
	file = e.split("/")[-1]  # grab the actual file name with out the path
	name = file.split(".")[0] # chop the extension off
	cid = fetch(CLASS_ID % (name))
	if cid is not None: # if the CID is not avalible we dont need to add an Exam as we dont have a class for it to be linked to.....
		print(color.OKGREEN+"EXAM: "+name+color.END)
		with open(e,'rb') as file:
			o = [] #reset list
			for line in file:
				if question.match(line) is not None:
					q = MySQLdb.escape_string(line.rstrip())
					q_number = q.split(".")[0]
					q_text = re.sub('\A\s','',q.split(".")[1]) # Strip the white space off the front of the line
				elif option.match(line) is not None:
					o.append(MySQLdb.escape_string(re.sub('\A[A-D]:','', line.rstrip()))) # append question to list remove A: B: C: D: from the line and the \n off the end
				elif answer.match(line) is not None:
					a = MySQLdb.escape_string(line.rstrip())
					InsertExam(INSERT_EXAM_LINE % (cid[0],q_number,q_text,o[0],o[1],o[2],o[3],a)) # push the Q & A to the SQL server
					o = [] # reset list of answers at the end of each section since the Answer is always last

	else: # and so we skip it and tell the user which one was skipped using the WARNING color
		print("\t%sWARNING: Skipping Exam: %s --> No ClassID on file.%s" % (color.WARNING,name,color.END))
