#!/usr/bin/env python
 
import os
import glob
import sys
#import time
import datetime

import argparse

MAX_AGE_HOURS = 36
DIR_TO_SEARCH = "/home/jherr/cubbyfs/MassRecordings/flagdir"
DEFAULT_EXT="py"

def findLatestFile(fileToMatchIn):
  latest_file = ""
  latest_time = 0

  for x in glob.iglob(fileToMatchIn):
    fileTime = os.path.getmtime(x)
##    print "%60s %s" % (x, fileTime)

    if( (latest_time == 0) or fileTime > latest_time):
      latest_file = x
      latest_time = fileTime

  return latest_file, datetime.datetime.fromtimestamp(latest_time)

def parseArgs():
  parser = argparse.ArgumentParser()
  parser.add_argument("-m", "--maxhrs", type=int, default=MAX_AGE_HOURS,
   help="Maximum acceptable age (in hours) of the most recent file, default="+repr(MAX_AGE_HOURS))
  parser.add_argument("-d", "--dir", default=DIR_TO_SEARCH,
    help="Directory to search, default=\'"+DIR_TO_SEARCH+"\'")
  parser.add_argument("-x", "--ext", default=DEFAULT_EXT,
    help="File extension to search for, default=\'"+DEFAULT_EXT+"\'")
  args = parser.parse_args()

#  print maxhrsallowed
  return args.maxhrs, args.ext, args.dir

def main():
  rtn = 0

  maxHrsOld, fileExtension, directory = parseArgs()

  lastFile, lastDate = findLatestFile(directory+'/*.'+fileExtension)
  if( lastFile == "" ):
#    print "ERROR"
    rtn = 2
  elif( datetime.datetime.now() - lastDate > datetime.timedelta(hours=maxHrsOld) ):
#    print "OLD"
    rtn = 1
  else:
#    print "OKAY"
    rtn = 0

  return rtn

#-------------------- 

sys.exit(main())

