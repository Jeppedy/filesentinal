#!/bin/bash

binpath=`dirname ${0}`
logfile=${0}.log

${binpath}/filesentinal.py -x mp4 -d /home/jherr/cubbyfs/MassRecordings -m 8
x=$?
#echo "MP4 Return Code:$x"

if [ $x == 2 ]; then  # None found
  echo "GOOD: No MP4s found!"
elif [ $x == 0 ]; then  # Found and new
  echo "GOOD: Current MP4s found!"
elif [ $x == 1 ]; then  # too old
  echo "PROBLEM: Old MP4s found!"
  curl -s -d "user_credentials=Xjj4BDIkslAvl4MOIJdD" \
     -d "notification[title]=Old MP4s - Mass Recorder Alert" \
     -d "notification[long_message]=<p>Old MP4s are still in the MassRecorder Cubby folder.  This usually means the sweeper is not running.</p>" \
     -d "notification[sound]=bird-1" \
     -d "notification[source_name]=MassRecorder" \
     https://new.boxcar.io/api/notifications >> ${logfile}
     echo "" >> ${logfile}

  curl https://api.sendgrid.com/api/mail.send.json \
    -s \
    -F to=jeff@theherrs.com \
    -F toname=Jeff \
    -F from=jeffrey.herr@gmail.com \
    -F fromname=Jeppedy \
    -F subject="Old MP4s Found" \
    -F text="Old MP4s Found" \
    -F api_user=JeffHerr \
    -F api_key=sh0tnews1 >> ${logfile}

  exit 1
fi

# in hours...
${binpath}/filesentinal.py -x txt -d /home/jherr/cubbyfs/MassRecordings/flagdir -m 30
x=$?
#echo "FlagFile Return Code:$x"

if [ $x == 2 ]; then  # None found
  echo "PROBLEM: No flag file found!"
  curl -s -d "user_credentials=Xjj4BDIkslAvl4MOIJdD" \
     -d "notification[title]=No FlagFile - Mass Recorder Alert" \
     -d "notification[long_message]=<p>No flag file was found in the MassRecorder Cubby folder.</p>" \
     -d "notification[sound]=bird-1" \
     -d "notification[source_name]=MassRecorder" \
     https://new.boxcar.io/api/notifications >> ${logfile}
     echo "" >> ${logfile}

  curl https://api.sendgrid.com/api/mail.send.json \
    -s \
    -F to=jeff@theherrs.com \
    -F toname=Jeff \
    -F from=jeffrey.herr@gmail.com \
    -F fromname=Jeppedy \
    -F subject="No flag file Found" \
    -F text="No flag file Found" \
    -F api_user=JeffHerr \
    -F api_key=sh0tnews1 >> ${logfile}
  exit -1
elif [ $x == 0 ]; then  # Found and new
  echo "GOOD: Current flag file found!"
elif [ $x == 1 ]; then  # too old
  echo "PROBLEM: Old flag File Found!"
  curl -s -d "user_credentials=Xjj4BDIkslAvl4MOIJdD" \
     -d "notification[title]=Old FlagFile - Mass Recorder Alert" \
     -d "notification[long_message]=<p>An OLD flag file was found in the MassRecorder Cubby folder.  This usually means no videos are being recorded.</p>" \
     -d "notification[sound]=bird-1" \
     -d "notification[source_name]=MassRecorder" \
     https://new.boxcar.io/api/notifications >> ${logfile}
     echo "" >> ${logfile}

  curl https://api.sendgrid.com/api/mail.send.json \
    -s \
    -F to=jeff@theherrs.com \
    -F toname=Jeff \
    -F from=jeffrey.herr@gmail.com \
    -F fromname=Jeppedy \
    -F subject="Old flag file Found" \
    -F text="Old flag file Found" \
    -F api_user=JeffHerr \
    -F api_key=sh0tnews1 >> ${logfile}
  exit 2
fi

exit 0
