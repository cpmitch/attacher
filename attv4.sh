#!/bin/bash
# -------------------------------------------------------------------------
# Version 01 24-Nov-2012 to read line-by-line from file check_macs.txt
# And then print a line telling me how long it's been since that MAC
# address has been seen and what its common name is.
#
#  2-Jan-2020:
# Changing the HUNG code reporting just a bit, and no longer sending a text when HUNG detected, no longer SENDEMAILALERT either.
SENDEMAILALERT ()
{
   if [ "$EVENTTYPE" == "Back" ] ; then
      MESSAGE="$EVENTTYPE ($ASSOCESSID2) $SCRIPTNAME $F2, OUI $MACSTRING $((10#$(date +%m) + 0))/$((10#$(date +%d) + 0))/$(date +%Y)  $(date +%T), last seen $LEGACYDAYS$DAY $LEGACYMODHOURS$HOUR $LEGACYMODMINS$MIN ago by $HOSTNAME"
      # echo "$EVENTTYPE $SCRIPTNAME ($ASSOCESSID2) $F2, OUI $MACSTRING, $(date +%D) $(date +%T), last seen '$LEGACYDAYS' d, '$LEGACYMODHOURS' h, '$LEGACYMODMINS' m ago by $HOSTNAME"
      CHECKCLIENTBLACKLIST
      CHECKAPGREENLIST
      # echo $MESSAGE >> $SANDBOX/$F1"_history.txt"
      if ( [ "$ISCLIENTMACBLACKLISTED" == "NO" ] && [ "$ISAPMACGREENLISTED" == "YES" ] ) ; then
         echo $MESSAGE >> $HOMEP/"$HOSTNAME".txt
         echo "<P>" >> $HOMEP/"$HOSTNAME".txt
      fi
   fi
   if [ "$EVENTTYPE" == "Gone" ] ; then
      DATEADJUSTED=$(echo $LEGACYDATE | awk -F- '{ print $2 + 0 "/" $3 + 0 "/" $1}')
      TIMEADJUSTED=$(echo $LEGACYDATE | awk -F- '{ print $3 }')
      # MESSAGE="$EVENTTYPE $SSID2 $F2, OUI $OUISTRING, last seen $DATEADJUSTED ${TIMEADJUSTED:3:8}, thrsh $QUIETTHRESH$MIN elapsed $ELAPSEDMINS$MIN, by $HOSTNAME"
      MESSAGE="$EVENTTYPE ($ASSOCESSID2) $SCRIPTNAME $F2, OUI $MACSTRING, last seen $DATEADJUSTED ${TIMEADJUSTED:3:8} ($ELAPSEDMINS$MIN ago) by $HOSTNAME"
      # echo "$EVENTTYPE $SCRIPTNAME ($ASSOCESSID2) $F2, OUI $MACSTRING, elapsed $ELAPSEDMINS last seen $LEGACYDATE m $HOSTNAME"
      CHECKCLIENTBLACKLIST
      CHECKAPGREENLIST
      # echo $MESSAGE >> $SANDBOX/$F1"_history.txt"
      if ( [ "$ISCLIENTMACBLACKLISTED" == "NO" ] && [ "$ISAPMACGREENLISTED" == "YES" ] ) ; then
         echo $MESSAGE >> $HOMEP/"$HOSTNAME".txt
         echo "<P>" >> $HOMEP/"$HOSTNAME".txt
      fi
   fi
   if [ "$EVENTTYPE" == "Newly-Arrived" ] ; then
      MESSAGE="$EVENTTYPE ($ASSOCESSID2) $SCRIPTNAME $F2, OUI $MACSTRING, first seen $MONTH2/$DAY2/$YEAR2  $HR2:$MIN2:$SEC2 Non: $CLIENTNONHISTORY by $HOSTNAME"
      echo "$EVENTTYPE $SCRIPTNAME $F2, OUI $MACSTRING, first seen $MONTH2/$DAY2/$YEAR2 $HR2:$MIN2:$SEC2, latched '($ASSOCESSID2)' by $HOSTNAME"
      CHECKCLIENTBLACKLIST
      CHECKAPGREENLIST
      # echo $MESSAGE >> $SANDBOX/$F1"_history.txt"
      if ( [ "$ISCLIENTMACBLACKLISTED" == "NO" ] && [ "$ISAPMACGREENLISTED" == "YES" ] ) ; then
         echo $MESSAGE >> $HOMEP/"$HOSTNAME".txt
         echo "<P>" >> $HOMEP/"$HOSTNAME".txt
         # Following added 29-Nov-2016 to spawn xterm, launch new testv14 script against client..."
         # CHECKFOREXISTINGLINEPROCESS
      fi
   fi
   if [ "$EVENTTYPE" == "Roamed-Here" ] ; then
      # MESSAGE="$EVENTTYPE ($ASSOCESSID2) $SCRIPTNAME $F2, OUI $MACSTRING $((10#$(date +%m) + 0))/$((10#$(date +%d) + 0))/$(date +%Y) $(date +%T), last seen $LEGACYDAYS$DAY $LEGACYMODHOURS$HOUR $LEGACYMODMINS$MIN ago by $HOSTNAME"
      MESSAGE="$EVENTTYPE ($ASSOCESSID2) $SCRIPTNAME $F2, OUI $MACSTRING $((10#$(date +%m) + 0))/$((10#$(date +%d) + 0))/$(date +%Y) $(date +%T), Roamed To $ASSOCESSID2 from $PREVASSOCMACNAME by $HOSTNAME"
      # MESSAGE="$EVENTTYPE $F2, OUI $MACSTRING, latched to $SCRIPTNAME, $(date +%D) $(date +%T), by $HOSTNAME"
      # echo "$EVENTTYPE $F2, OUI $MACSTRING, latched to $SCRIPTNAME, $(date +%D) $(date +%T), by $HOSTNAME"
      echo "$EVENTTYPE $SCRIPTNAME $F2, OUI $MACSTRING, $(date +%D) $(date +%T), Roamed To $ASSOCESSID2 from $PREVASSOCMACNAME by $HOSTNAME"
      # echo $MESSAGE >> $SANDBOX/$F1"_history.txt"
      echo $MESSAGE >> $HOMEP/"$HOSTNAME".txt
      echo "<P>" >> $HOMEP/"$HOSTNAME".txt
   fi
   if [ "$EVENTTYPE" == "Roamed-Away" ] ; then
      MESSAGE="$EVENTTYPE ($ASSOCESSID2) $SCRIPTNAME $F2, OUI $MACSTRING $((10#$(date +%m) + 0))/$((10#$(date +%d) + 0))/$(date +%Y) $(date +%T), by $HOSTNAME"
      echo "$EVENTTYPE $SCRIPTNAME $F2, OUI $MACSTRING, $(date +%D) $(date +%T), by $HOSTNAME"
      echo $MESSAGE >> $HOMEP/"$HOSTNAME".txt
      # echo $MESSAGE >> $SANDBOX/$F1"_history.txt"
      echo "<P>" >> $HOMEP/"$HOSTNAME".txt
      # echo "\n\n" >> $HOMEP/"$HOSTNAME".txt
   fi
   if [ "$EVENTTYPE" == "undefined" ] ; then
      MESSAGE="$SCRIPTNAME Sad for you ... we got here somehow without defining the event ... Bye from $HOSTNAME"
      echo "$SCRIPTNAME Sad for you ... we got here somehow without defining the event ... Bye from $HOSTNAME"
      echo $MESSAGE >> $HOMEP/"$HOSTNAME".txt
      # echo $MESSAGE >> $SANDBOX/$F1"_history.txt"
      echo "<P>" >> $HOMEP/"$HOSTNAME".txt
   fi
   if [ "$EVENTTYPE" == "LOST" ] ; then
      MESSAGE="$EVENTTYPE ($ASSOCESSID2) $SCRIPTNAME Sad for $F2 OUI $MACSTRING once was observed, now missing from the .csv file at $HOSTNAME"
      echo "$EVENTTYPE $SCRIPTNAME ($ASSOCESSID2) Sad for $F2 OUI $MACSTRING once was observed, now missing from the .csv file at $HOSTNAME"
      CHECKCLIENTBLACKLIST
      CHECKAPGREENLIST
      # echo $MESSAGE >> $SANDBOX/$F1"_history.txt"
      if ( [ "$ISCLIENTMACBLACKLISTED" == "NO" ] && [ "$ISAPMACGREENLISTED" == "YES" ] ) ; then
         echo $MESSAGE >> $HOMEP/"$HOSTNAME".txt
         echo "<P>" >> $HOMEP/"$HOSTNAME".txt
      fi
   fi
   if [ "$EVENTTYPE" == "HUNG" ] ; then
      MESSAGE="$SCRIPTNAME Sad for you ... we got here since insane data still rules the day ... Looping at $HOSTNAME"
      echo "$SCRIPTNAME Sad for you ... we got here since insane data still rules the day ... Looping at $HOSTNAME"
      echo $MESSAGE >> $HOMEP/"$HOSTNAME".txt
      echo "<P>" >> $HOMEP/"$HOSTNAME".txt
   fi
   if [ "$EVENTTYPE" == "BADD" ] ; then
      MESSAGE="$SCRIPTNAME Sad for you ... we got here since insane data namely elapsed days = $ELAPSEDDAYS still rules the day ... Looping at $HOSTNAME"
      echo "$SCRIPTNAME Sad for you ... we got here since insane data namely elapsed days = $ELAPSEDDAYS still rules the day ... Looping at $HOSTNAME"
      echo $MESSAGE >> $HOMEP/"$HOSTNAME".txt
      echo "<P>" >> $HOMEP/"$HOSTNAME".txt
   fi


   TOLIST="xxxxxxxxxxx@gmail.com"
   CCLIST=""

   # echo ">>>>> The sendemail marker found, event = $EVENTTYPE, mobile = $F2, AP = $SCRIPTNAME, OUI = $MACSTRING, so sending the e-mail alert ---------"

   # Note below may be dead code since I haven't touched the sendemailatt file.
   # if [ -e $HOMEP/sendemailatt ] ; then
   # sendEmail -xu xxxxxxx -xp yyyyyyyyy \
   # -f xxxxxxx@gmail.com \
   # -t $TOLIST \
   # -u $SCRIPTNAME event $HOSTNAME \
   # -m $MESSAGE \
   # -o tls=yes \
   # -s smtp.gmail.com:587
   # Lesson learned: never place a variable that could be zero like ELAPSEDMINS in the -m field of sendEmail - it barfs.
   # Older versions had: -u $F2 event $FILE1 \
   # Older version had: -t xxxxxxx@gmail.com
   # fi

   if [ $FIRSTPASS1YES0NO -eq 0 ] ; then
      # if ( [ $LEGACYDAYS -gt 4 ] || [ "$EVENTTYPE" == "Newly-Arrived" ] ) ; then
      if ( [[ $LEGACYMINS -gt $MINUTES6480 ]] || [ "$EVENTTYPE" == "Newly-Arrived" ] ) ; then
         CHECKCLIENTBLACKLIST
         CHECKAPGREENLIST
         CHECKOUIBLACKLIST
         # if ( [ "$ISCLIENTMACBLACKLISTED" == "NO" ] && [ "$ISAPMACGREENLISTED" == "YES" ] ) ; then
         if ( [ "$ISCLIENTMACBLACKLISTED" == "NO" ] && [ "$ISAPMACGREENLISTED" == "YES" ] && [ "$ISCLIENTOUIBLACKLISTED" == "NO" ] ) ; then
            # At this point we know enough to send a text, but next perform discovery of the client's history...
            CLIENTNONHISTORY="No History"
            if [ -e $SANDBOXNON/$F1"_history.txt" ] ; then
               CLIENTNONHISTORY=$(cat $SANDBOXNON/$F1"_history.txt" | grep -m1 non | awk '{ print $1, $2, $3, $4 }')
            fi
            case $EVENTTYPE in
               Newly-Arrived) echo "++N++ $(date +%a) $(date +%D) $(date +%T) + $SCRIPTNAME ($ASSOCESSID2) $EVENTTYPE $F2 last seen $LEGACYDAYS$DAY $LEGACYMODHOURS$HOUR $LEGACYMODMINS$MIN ago, Non: $CLIENTNONHISTORY $HOSTNAME" >> $HOMEP/master_log.txt
                              echo "++N++ $(date +%a) $(date +%D) $(date +%T) + $SCRIPTNAME ($ASSOCESSID2) $EVENTTYPE $F2 last seen $LEGACYDAYS$DAY $LEGACYMODHOURS$HOUR $LEGACYMODMINS$MIN ago, Non: $CLIENTNONHISTORY $HOSTNAME" >> $SANDBOX/$F1"_history.txt"
                              echo "++N++ $(date +%a) $(date +%D) $(date +%T) + $SCRIPTNAME ($ASSOCESSID2) $F2 $F1 OUI $MACSTRING last seen $LEGACYDAYS d, $LEGACYMODHOURS h, $LEGACYMODMINS m ago using $FILE1 $HOSTNAME" >> $SANDBOXAP/$ASSOCBSSID2"_history.txt"
                              # MESSAGE="++$EVENTTYPE ($ASSOCESSID2) $EVENTTYPE $SCRIPTNAME $F2 $MACSTRING, last $LEGACYDAYS$DAY $LEGACYMODHOURS$HOUR $LEGACYMODMINS$MIN ago $((10#$(date +%m) + 0))/$((10#$(date +%d) + 0))/$(date +%Y), $(date +%T), Non: $CLIENTNONHISTORY by $HOSTNAME"
                              MESSAGE="++$EVENTTYPE ($ASSOCESSID2) $EVENTTYPE $SCRIPTNAME $F2 $MACSTRING $((10#$(date +%m) + 0))/$((10#$(date +%d) + 0))/$(date +%Y), $(date +%T), Non: $CLIENTNONHISTORY by $HOSTNAME"
                              echo "+TXT+ $(date +%a) $(date +%D) $(date +%T) + $SCRIPTNAME ($ASSOCESSID2) $EVENTTYPE $F2 $MACSTRING, last seen $LEGACYDAYS$DAY $LEGACYMODHOURS$HOUR $LEGACYMODMINS$MIN ago, Non: $CLIENTNONHISTORY $HOSTNAME" >> $HOMEP/master_log.txt
                              echo "+TXT+ $(date +%a) $(date +%D) $(date +%T) + $SCRIPTNAME ($ASSOCESSID2) $EVENTTYPE $F2 $MACSTRING, last seen $LEGACYDAYS$DAY $LEGACYMODHOURS$HOUR $LEGACYMODMINS$MIN ago, Non: $CLIENTNONHISTORY $HOSTNAME" >> $SANDBOX/$F1"_history.txt"
                              echo "+TXT+ $(date +%a) $(date +%D) $(date +%T) + $SCRIPTNAME ($ASSOCESSID2) $F2 $F1 OUI $MACSTRING last seen $LEGACYDAYS d, $LEGACYMODHOURS h, $LEGACYMODMINS m ago using $FILE1 $HOSTNAME" >> $SANDBOXAP/$ASSOCBSSID2"_history.txt"
                              # Following added 29-Nov-2016 to spawn xterm, launch new testv14 script against client..."
                              # echo "+LIN+ $(date +%a) $(date +%D) $(date +%T) + $SCRIPTNAME ($ASSOCESSID2) $EVENTTYPE $F2 $MACSTRING new testv14 process" >> $HOMEP/master_log.txt
                              if [ -e $SANDBOXNON/$F1"_history.txt" ] ; then
                                 echo "++N++ $(date +%a) $(date +%D) $(date +%T) + $SCRIPTNAME ($ASSOCESSID2) $EVENTTYPE $F2 last seen $LEGACYDAYS$DAY $LEGACYMODHOURS$HOUR $LEGACYMODMINS$MIN ago, Non: $CLIENTNONHISTORY $HOSTNAME" >> $SANDBOXNON/$F1"_history.txt"
                                 echo "+TXT+ $(date +%a) $(date +%D) $(date +%T) + $SCRIPTNAME ($ASSOCESSID2) $EVENTTYPE $F2 $MACSTRING, last seen $LEGACYDAYS$DAY $LEGACYMODHOURS$HOUR $LEGACYMODMINS$MIN ago, Non: $CLIENTNONHISTORY $HOSTNAME" >> $SANDBOXNON/$F1"_history.txt"
                              fi 
                              CHECKFOREXISTINGLINEPROCESS;;
                        Back) echo "++B++ $(date +%a) $(date +%D) $(date +%T) + $SCRIPTNAME ($ASSOCESSID2) $EVENTTYPE $F2 last seen $LEGACYDAYS$DAY $LEGACYMODHOURS$HOUR $LEGACYMODMINS$MIN ago, $HOSTNAME" >> $HOMEP/master_log.txt
                              echo "++B++ $(date +%a) $(date +%D) $(date +%T) + $SCRIPTNAME ($ASSOCESSID2) $EVENTTYPE $F2 last seen $LEGACYDAYS$DAY $LEGACYMODHOURS$HOUR $LEGACYMODMINS$MIN ago, $HOSTNAME" >> $SANDBOX/$F1"_history.txt"
                              echo "++B++ $(date +%a) $(date +%D) $(date +%T) + $SCRIPTNAME ($ASSOCESSID2) $F2 $F1 OUI $MACSTRING last seen $LEGACYDAYS d, $LEGACYMODHOURS h, $LEGACYMODMINS m ago using $FILE1 $HOSTNAME" >> $SANDBOXAP/$ASSOCBSSID2"_history.txt"
                              MESSAGE="++$EVENTTYPE ($ASSOCESSID2) $EVENTTYPE $SCRIPTNAME $F2 $MACSTRING, last $LEGACYDAYS$DAY $LEGACYMODHOURS$HOUR $LEGACYMODMINS$MIN ago $((10#$(date +%m) + 0))/$((10#$(date +%d) + 0))/$(date +%Y), $(date +%T) by $HOSTNAME"
                              echo "+TXT+ $(date +%a) $(date +%D) $(date +%T) + $SCRIPTNAME ($ASSOCESSID2) $EVENTTYPE $F2 $MACSTRING, last seen $LEGACYDAYS$DAY $LEGACYMODHOURS$HOUR $LEGACYMODMINS$MIN ago $HOSTNAME" >> $HOMEP/master_log.txt
                              echo "+TXT+ $(date +%a) $(date +%D) $(date +%T) + $SCRIPTNAME ($ASSOCESSID2) $EVENTTYPE $F2 $MACSTRING, last seen $LEGACYDAYS$DAY $LEGACYMODHOURS$HOUR $LEGACYMODMINS$MIN ago $HOSTNAME" >> $SANDBOX/$F1"_history.txt"
                              echo "+TXT+ $(date +%a) $(date +%D) $(date +%T) + $SCRIPTNAME ($ASSOCESSID2) $F2 $F1 OUI $MACSTRING last seen $LEGACYDAYS d, $LEGACYMODHOURS h, $LEGACYMODMINS m ago using $FILE1 $HOSTNAME" >> $SANDBOXAP/$ASSOCBSSID2"_history.txt"
                              # Following added 29-Nov-2016 to spawn xterm, launch new testv14 script against client..."
                              # echo "+LIN+ $(date +%a) $(date +%D) $(date +%T) + $SCRIPTNAME ($ASSOCESSID2) $EVENTTYPE $F2 $MACSTRING new testv14 process" >> $HOMEP/master_log.txt
                              if [ -e $SANDBOXNON/$F1"_history.txt" ] ; then
                                 echo "++B++ $(date +%a) $(date +%D) $(date +%T) + $SCRIPTNAME ($ASSOCESSID2) $EVENTTYPE $F2 last seen $LEGACYDAYS$DAY $LEGACYMODHOURS$HOUR $LEGACYMODMINS$MIN ago, $HOSTNAME" >> $SANDBOX/$F1"_history.txt"
                                 echo "+TXT+ $(date +%a) $(date +%D) $(date +%T) + $SCRIPTNAME ($ASSOCESSID2) $EVENTTYPE $F2 $MACSTRING, last seen $LEGACYDAYS$DAY $LEGACYMODHOURS$HOUR $LEGACYMODMINS$MIN ago $HOSTNAME" >> $SANDBOXNON/$F1"_history.txt"
                              fi 
                              CHECKFOREXISTINGLINEPROCESS;;
            esac           

            echo $MESSAGE >> $HOMEP/"$HOSTNAME".txt
            echo "<P>" >> $HOMEP/"$HOSTNAME".txt
            # echo "\n\n" >> $HOMEP/"$HOSTNAME".txt
            # echo $MESSAGE >> $HOMEP/"$HOSTNAME".txt
            # echo "<P>" >> $HOMEP/"$HOSTNAME".txt
            echo "      Special event, so also TXT..."
            CCLIST="18005551212@mms.cricketwireless.net"
            sendEmail -xu xxxxx -xp yyyyyyy \
            -f xxxxxxxxx@gmail.com \
            -t $TOLIST \
            -cc $CCLIST \
            -u TXT \
            -m $MESSAGE \
            -o tls=yes \
            -o message-content-type=text \
            -s smtp.gmail.com:587
            # LEGACYMINS=0
            LEGACYDAYS=0
         fi
      fi
   fi
} # SENDEMAILALERT ()

#######################################################################################
sendTEXTMESSAGE () {

   echo "Special event: so sending a text..."
   CCLIST="800@551212icketwireless.net"
   sendEmail -xu xxxxxx -xp yyyy \
   -f xxxxxx@gmail.com \
   -t $TOLIST \
   -cc $CCLIST \
   # -t $CCLIST \
   -u attv4 event $HOSTNAME \
   -m $MESSAGE \
   -o message-content-type=html \
   -o tls=yes \
   -s smtp.gmail.com:587
   # Lesson learned: never place a variable that could be zero like ELAPSEDMINS in the -m field of sendEmail - it barfs.

}

date2stamp () {
    date --utc --date "$1" +%s
}

stamp2date (){
    date --utc --date "1970-01-01 $1 sec" "+%Y-%m-%d %T"
}

dateDiff (){
    case $1 in
        -s)   sec=1;      shift;;
        -m)   sec=60;     shift;;
        -h)   sec=3600;   shift;;
        -d)   sec=86400;  shift;;
        *)    sec=86400;;
    esac
    dte1=$(date2stamp $1)
    dte2=$(date2stamp $2)
    diffSec=$((dte2-dte1))
    if ((diffSec < 0)); then abs=-1; else abs=1; fi
    echo $((diffSec/sec*abs))
}

CHECKCLIENTGREENLIST (){
   cat $HOMEP/client_greenlist.txt | grep $F1
   RC=$?
   case $RC in
      0)   ISCLIENTMACGREENLISTED=YES; echo "******** This client MAC $F1 <==> $F2 is greenlisted, event will report in e-mail." ;;
      1)   ISCLIENTMACGREENLISTED=NO;;
   esac
}

CHECKAPGREENLIST (){
   cat $HOMEP/ap_greenlist.txt | grep $ASSOCBSSID2 | grep -v "#"
   RC=$?
   case $RC in
      0)   ISAPMACGREENLISTED=YES; echo "******** This AP MAC $ASSOCBSSID2 is greenlisted, event will report in e-mail." ;;
      1)   ISAPMACGREENLISTED=NO;;
   esac
}

CHECKCLIENTBLACKLIST (){
   cat $HOMEP/client_blacklist.txt | grep $F1
   RC=$?
   case $RC in
      0)   ISCLIENTMACBLACKLISTED=YES; echo "******** This client MAC $F1 <==> $F2 is blacklisted, event will NOT report in e-mail." ;;
      1)   ISCLIENTMACBLACKLISTED=NO;;
   esac
}

CHECKOUIBLACKLIST (){
   cat $HOMEP/blacklist_oui.txt | grep $SHORTMAC
   RC=$?
   case $RC in
      0)   ISCLIENTOUIBLACKLISTED=YES; echo "******** This client OUI $F1 <==> $F2 is blacklisted, event will NOT report in e-mail." ;;
      1)   ISCLIENTOUIBLACKLISTED=NO;;
   esac
}

CHECKFOREXISTINGLINEPROCESS (){
   ps -ef | grep test | grep -i $F1
   RC=$?
   case $RC in
      0)   echo "Found pre-existing line process, not spawning a new one...";;
      1)   echo "Found NO pre-existing line process, so spawn new window and start!";
           echo "Now we find a way to label and place the client in the check_macs.txt file..."
           if [ $UNKNOWNMAC -eq 1 ] ; then
              # echo "Our MAC = $F1 was not found in our custom database of known MACs..."
              NEWCHECKMACSTXTLINE=$F1"        "$ASSOCESSID2-New-$(date +%d)$(date +%b)$(date +%Y)--$(date +%H)-$(date +%M)-$(date +%S)
              echo $NEWCHECKMACSTXTLINE >> $HOMEP/check_macs.txt
              F2=$ASSOCESSID2-New-$(date +%d)$(date +%b)$(date +%Y)--$(date +%H)-$(date +%M)-$(date +%S)
           fi
           echo "+LIN+ $(date +%a) $(date +%D) $(date +%T) + $SCRIPTNAME ($ASSOCESSID2) $EVENTTYPE $F2 $MACSTRING new testv14 process" >> $HOMEP/master_log.txt;
           echo "+LIN+ $(date +%a) $(date +%D) $(date +%T) + $SCRIPTNAME ($ASSOCESSID2) $EVENTTYPE $F2 $MACSTRING new testv14 process" >> $SANDBOX/$F1"_history.txt"
           if [ -e $SANDBOXNON/$F1"_history.txt" ] ; then
              echo "+LIN+ $(date +%a) $(date +%D) $(date +%T) + $SCRIPTNAME ($ASSOCESSID2) $EVENTTYPE $F2 $MACSTRING new testv14 process" >> $SANDBOXNON/$F1"_history.txt"
           fi
           # xterm -bg grey -fg black -geometry 291x20 -fn 6x10 -e "homep;./testv14.sh csvfile $F1;bash" & ;;
           # xterm -bg grey -fg black -geometry 291x20 -fn 6x10 -e "bash testv14.sh csvfile $F1" & ;;
           # Below launches an xterm that fits nicely with the reduced VNC window:
           nohup xterm -bg grey -fg black -geometry 201x20 -fn 6x10 -e "bash testv14.sh csvfile $F1" & ;;
   esac
}
#######################################################################################
weedOutLine()
{
   line="$@" # get all args
   # UNKNOWNMAC=0

   # F1 is simply the MAC address of the mobile
   # getCURRENTDATE
   ASSOCLASTSEENDATEFROMCSV=$(echo $line | awk -F" " '{ print $2, $3 }')
   ASSOCLASTSEENMINUTESAGOFROMCSV=$(dateDiff -m $CURRENTDATE $ASSOCLASTSEENDATEFROMCSV)
   if [ $ASSOCLASTSEENMINUTESAGOFROMCSV -lt 180 ] ; then
      echo $line >> $SANDBOX/"$ASSOC".txt
      echo -n "+"
   else
      echo -n "-"
   fi
   if [ $FIRSTPASS -eq 0 ] ; then 
     # If this is the first pass, then go quickly, otherwise for all subsequent passes, go more slowly...
     sleep 0.110000
   fi   
}
#######################################################################################
getCURRENTDATE (){

   CURRENTDATE1="2014-10-18 22:16:30"
   CURRENTDATE2="2014-10-18 22:16:31"
   # LASTSEENDATE=$(awk '{ print $1 }' $SANDBOX/$MAC"_last_seen.txt")
   # LEGACYDATE=$(cat $SANDBOX/$MAC"_last_seen.txt")
   # LASTSEENDATE=$(cat $SANDBOX/$MAC"_last_seen.txt")
   until [ "$CURRENTDATE1" == "$CURRENTDATE2" ] ; do
      CURRENTDATE1="$(date '+%Y')-$(date '+%m')-$(date '+%d') $(date '+%H'):$(date '+%M'):$(date '+%S')"
      sleep 0.250000
      CURRENTDATE2="$(date '+%Y')-$(date '+%m')-$(date '+%d') $(date '+%H'):$(date '+%M'):$(date '+%S')"
   done
   CURRENTDATE=$CURRENTDATE1
}

CHECKFORPAUSE ()
{
while [ -e ./pause ] ; do
   echo "--$HOSTNAME box locally paused, delete to continue"
   sleep 5
done # Checking for pause

while [ -e $HOMEP/pause ] ; do
   echo "--$HOSTNAME box globaly paused, delete to continue"
   sleep 5
done # Checking for pause
}

CHECKFORSTOP ()
{
if [ -e ./stop ] ; then
   echo "--$HOSTNAME box locally file stop1 detected, so stoppping ..."
   exit 0
fi

if [ -e $HOMEP/stop ] ; then
   echo "--$HOSTNAME box globaly file stop1 detected, so stoppping ..."
   exit 0
fi
}

#######################################################################################
processLine()
{
    line="$@" # get all args
   UNKNOWNMAC=0

   # F1 is simply the MAC address of the mobile
   F1=$(echo $line | awk '{ print $1 }')

   # Now dip into our custom OUI databse for another method to determine who the mobile is.
   SHORTMAC=${F1:0:8}
   MACSTRING=$(cat $HOMEP/oui_custom.txt | grep -i $SHORTMAC | awk '{ print $2" "$3" "$4" "$5" "$6" "$7}' | sed -e 's/[[:space:]]*$//')

   # F2 is the common name we think the MAC really is.
   F2=$(cat $HOMEP/check_macs.txt | grep -ai $F1 | awk '{ print $2 }')

   if [ "$F2" == "" ] ; then
      # echo "Our MAC = $F1 was not found in our custom database of known MACs..."
      F2=$F1"_unkMAC"
      UNKNOWNMAC=1
      # echo "So we will use $F2 for the local descriptor."
   fi

   if [ "$MACSTRING" == "" ] ; then
      # echo "Our MAC = $F1 was not found in the custom OUI database..."
      # MACSTRING=$F1"_unkOUI"
      MACSTRING=${F1:0:8}"_unkOUI"
      # echo "So we will use $MACSTRING for the OUI descriptor."
      cat $UNKNOWNOUIFILE | grep $SHORTMAC
      RC=$?
      if [ $RC -eq 1 ] ; then
         echo $SHORTMAC >> $HOMEP/unkOUI.txt
      fi
   fi

   # First thing to do is estbalish persistnece for the client. We do this by setting
   # a marker file in the sandbox directory which will contain a 0 or 1. If the file
   # contains a 0 that means the leave threshold has been exceeded. If the the file
   # contains 1 that means the client has been seen within the threshold setting, and
   # he is considered nearby.
   touch $SANDBOX/$F1"_is_fresh.txt"
   # touch $SANDBOX/$F1"_last_seen.txt"
   # touch $SANDBOX/$F1"_last_powr.txt"
   # touch $SANDBOX/$F1"_last_data.txt"

   CLIENTMARKER=$(cat $SANDBOX/$F1"_is_fresh.txt")

# The following until-do-done loop is a safeguard against the crazy nonesense data sometimes
# retrieved when dealing with airodump-ng's .csv files. It has become necessary since some
# out of range numbers are being returned on a regular basis. Of course the assumption is that
# consecutive sampled minutes won't both be equally insane. If so, I have yet another problem...

# Init the variables...
LEGACYDAYS=0 ; LEGACYMODHOURS=0 ; LEGACYMODMINS=0
LEGACYHOURS=0; LEGACYMINS=0
SECOND1=0  ; MINUTE1=0  ; HOUR1=0  ; DAY1=0  ; MONTH1=0  ; YEAR1=0
SECOND2=1  ; MINUTE2=1  ; HOUR2=1  ; DAY2=1  ; MONTH2=1  ; YEAR2=1
LOOPPASS=0
ASSOCBSSID1LENGTH=1
ASSOCBSSID2LENGTH=2
ASSOCSSIDLENGTH=17
NEGONE=-1
NONASSOC="(not"
NOTASSOCIATED="(not associated)"
PROBES1="a"
PROBES2="b"
MACAPPEARSTIMES=-1


until [ $SECOND1 -eq $SECOND2 ] && \
      [ $MINUTE1 -eq $MINUTE2 ] && \
      [ $HOUR1 -eq $HOUR2 ] && \
      [ $DAY1 -eq $DAY2 ] && \
      [ $MONTH1 -eq $MONTH2 ] && \
      [ "$ASSOCBSSID1" == "$ASSOCBSSID2" ] && \
      [ $YEAR1 -eq $YEAR2 ] && \
      # 18-Oct-2015 adding the following line back into the mix since false positive Roamer-Here code is getting triggered...
      (( ( $ASSOCBSSID1LENGTH == 17 ) || ( $ASSOCBSSID1LENGTH == 0 ) )) || \
      (( ( $MACAPPEARSTIMES == 0 ) && ( $LOOPPASS >= 4 ) )) ; do

   echo -n "."

   #### Bug - if Carr's old AP client combo is any indication, this code doesn't correctly detect the right AP versus client.
   #### Maybe need to assign CSVSTRING to something that takes into account the power value (a negative number) versus the data count
   #### which is always greater than zero.
   ####
   CSVSTRING=$(egrep -a -m 2 $F1 $FILE1 | awk -F, '{ print $1 $2 $3 }')
   CSVSTRINGLENGTH=${#CSVSTRING}

   ### Following line detects when the client MAC appears not even once in the csv file. The returned string is always exactly 0 chars long.
   if [ $CSVSTRINGLENGTH -eq 0 ] ; then
      # echo "Appears not at all..."
      LASTSEENDATE=$(awk '{ print $1 }' $SANDBOX/$F1"_last_seen.txt")
      MACAPPEARSTIMES=0
   fi

   if [ $CSVSTRINGLENGTH -eq 115 ] ; then
      echo "Appears more than once -- MAC = $F1, <==> $F2,  so grabbing the correct last seen times."
      MACAPPEARSTIMES=2
   fi

   # Following lines added 6-Oct-2015 to correctly grab the client line from the csvfile. Because a device can act as both AP and client,
   # such as in the case of a repeater, it is necessary to target the correct data in the csvfile.
   # CSVSTRING=$(awk -v threshold=0 -F, '$4 < threshold' $FILE1 | grep -ai $F1 | awk -F, '{ print $1 $2 $3 }')
   CSVSTRING=$(awk -v threshold=0 -v mac="$F1" -F, '$1==mac && $4 < threshold' $FILE1 | grep -ai $F1 | awk -F, '{ print $1 $2 $3 }')
   CSVSTRINGLENGTH=${#CSVSTRING}

   ### Following line detects when the client MAC appears just once in the csv file. The returned string is always exactly 57 chars long.
   if [ $CSVSTRINGLENGTH -eq 57 ] ; then

      MACAPPEARSTIMES=1

      SEC1=${CSVSTRING:55:2}
      SECOND1="$(echo $SEC1 | awk '{print $1 + 0}')"
      # echo "Found SECOND1=$SECOND1,so moving on..."

      MIN1=${CSVSTRING:52:2}
      MINUTE1="$(echo $MIN1 | awk '{print $1 + 0}')"
      # echo "Found MINUTE1=$MINUTE1,so moving on..."

      HR1=${CSVSTRING:49:2}
      HOUR1="$(echo $HR1 | awk '{print $1 + 0}')"
      # echo "Found HOUR1=$HOUR1,so moving on..."

      DY1=${CSVSTRING:46:2}
      DAY1="$(echo $DY1 | awk '{print $1 + 0}')"
      # echo "Found DAY1=$DAY1,so moving on..."

      MON1=${CSVSTRING:43:2}
      MONTH1="$(echo $MON1 | awk '{print $1 + 0}')"
      # echo "Found MONTH1=$MONTH1,so moving on..."

      YR1=${CSVSTRING:38:4}
      YEAR1="$(echo $YR1 | awk '{print $1 + 0}')"
      # echo "Found YEAR1=$YEAR1,so moving on..."
   fi

   ### Following line detects when the client MAC appears TWICE     in the csv file. The returned string is always exactly 115 chars long.
   if [ $CSVSTRINGLENGTH -eq 115 ] ; then

      echo "Appears more than once -- MAC = $F1, <==> $F2,  so grabbing the correct last seen times."
      MACAPPEARSTIMES=2

      SEC1=${CSVSTRING:113:2}
      SECOND1="$(echo $SEC1 | awk '{print $1 + 0}')"
      # echo "Found SECOND1=$SECOND1,so moving on..."

      MIN1=${CSVSTRING:110:2}
      MINUTE1="$(echo $MIN1 | awk '{print $1 + 0}')"
      # echo "Found MINUTE1=$MINUTE1,so moving on..."

      HR1=${CSVSTRING:107:2}
      HOUR1="$(echo $HR1 | awk '{print $1 + 0}')"
      # echo "Found HOUR1=$HOUR1,so moving on..."

      DY1=${CSVSTRING:104:2}
      DAY1="$(echo $DY1 | awk '{print $1 + 0}')"
      # echo "Found DAY1=$DAY1,so moving on..."

      MON1=${CSVSTRING:101:2}
      MONTH1="$(echo $MON1 | awk '{print $1 + 0}')"
      # echo "Found MONTH1=$MONTH1,so moving on..."

      YR1=${CSVSTRING:96:4}
      YEAR1="$(echo $YR1 | awk '{print $1 + 0}')"
      # echo "Found YEAR1=$YEAR1,so moving on..."
   fi

   #############################################################################################################
   # As of v12 (inherited from the scan.sh) we are going to collect and report the BSSID each client is actually attached to...
   #############################################################################################################
   ASSOCSSID=$(egrep -a $F1 $FILE1 | awk -v minus1="$NEGONE" -v mac="$F1" -F',' '$1==mac && $5!=minus1 && length($6)==18 {print $1, $2, $3, $4, $5, $6}' | awk '{ print $8 }')
   # ASSOCSSID=$(awk -v minus1="$NEGONE" -v mac="$F1" -F', ' '$1==mac && $5!=minus1 && $6<1 {print $1, $2, $3, $4, $5, $6}' $FILE1 | awk '{ print $8 }')
   # ASSOCSSID=$(cat $FILE1 | grep -ai $F1 | awk -F, '{ print $6 }')
   # ASSOCSSID=$(awk -F, '{print $6}' $FILE1 | grep -ai $F1)
   ASSOCBSSID1=$(echo $ASSOCSSID | sed -e 's/^ *//' -e 's/^ *$//')
   # ASSOCBSSID1=${ASSOCSSID:$ASSOCPREFIX:$ASSOCSUFFIX}
   # echo "Found ASSOCSSID = $ASSOCSSID, so moving on..."
   ASSOCBSSID1LENGTH=${#ASSOCBSSID1}

   #### The following if statement captures the fact that a client may have once associated to our AP,
   #### but now does not, and simply hangs out with WiFi turned on, but found to be (not associated) in .csv file.
   if [ "$ASSOCSSID" == "$NONASSOC" ] ; then
      ASSOCBSSID1LENGTH=0
   fi
   # echo "Found ASSOCBSSID1 = $ASSOCBSSID1, so moving on..."
   # echo "Found ASSOCBSSID1LENGTH = $ASSOCBSSID1LENGTH, so moving on..."


   #############################################################################################################
   # usleep 250000
   # sleep 1                                H A L F T I M E 
   sleep 0.500000
   #############################################################################################################

   CSVSTRING=$(egrep -a -m 2 $F1 $FILE1 | awk -F, '{ print $1 $2 $3 }')
   CSVSTRINGLENGTH=${#CSVSTRING}

   ### Following line detects when the client MAC appears not even once in the csv file. The returned string is always exactly 0 chars long.
   if [ $CSVSTRINGLENGTH -eq 0 ] ; then
      # echo "Appears not at all..."
      LASTSEENDATE=$(awk '{ print $1 }' $SANDBOX/$F1"_last_seen.txt")
      MACAPPEARSTIMES=0
   fi

   if [ $CSVSTRINGLENGTH -eq 115 ] ; then
      # echo "Appears more than once -- MAC = $F1, <==> $F2,  so grabbing the correct last seen times."
      MACAPPEARSTIMES=2
   fi

   # Following lines added 6-Oct-2015 to correctly grab the client line from the csvfile. Because a device can act as both AP and client,
   # such as in the case of a repeater, it is necessary to target the correct data in the csvfile.
   # CSVSTRING=$(awk -v threshold=0 -F, '$4 < threshold' $FILE1 | grep -ai $F1 | awk -F, '{ print $1 $2 $3 }')
   CSVSTRING=$(awk -v threshold=0 -v mac="$F1" -F, '$1==mac && $4 < threshold' $FILE1 | grep -ai $F1 | awk -F, '{ print $1 $2 $3 }')
   CSVSTRINGLENGTH=${#CSVSTRING}

   ### Following line detects when the client MAC appears just once in the csv file. The returned string is always exactly 57 chars long.
   if [ $CSVSTRINGLENGTH -eq 57 ] ; then

      MACAPPEARSTIMES=1

      SEC2=${CSVSTRING:55:2}
      SECOND2="$(echo $SEC2 | awk '{print $1 + 0}')"
      # echo "Found SECOND2=$SECOND2,so moving on..."

      MIN2=${CSVSTRING:52:2}
      MINUTE2="$(echo $MIN2 | awk '{print $1 + 0}')"
      # echo "Found MINUTE2=$MINUTE2,so moving on..."

      HR2=${CSVSTRING:49:2}
      HOUR2="$(echo $HR2 | awk '{print $1 + 0}')"
      # echo "Found HOUR2=$HOUR2,so moving on..."

      DY2=${CSVSTRING:46:2}
      DAY2="$(echo $DY2 | awk '{print $1 + 0}')"
      # echo "Found DAY2=$DAY2,so moving on..."

      MON2=${CSVSTRING:43:2}
      MONTH2="$(echo $MON2 | awk '{print $1 + 0}')"
      # echo "Found MONTH2=$MONTH2,so moving on..."

      YR2=${CSVSTRING:38:4}
      YEAR2="$(echo $YR2 | awk '{print $1 + 0}')"
   fi

   ### Following line detects when the client MAC appears TWICE     in the csv file. The returned string is always exactly 115 chars long.
   if [ $CSVSTRINGLENGTH -eq 115 ] ; then

      MACAPPEARSTIMES=2

      SEC2=${CSVSTRING:113:2}
      SECOND2="$(echo $SEC2 | awk '{print $1 + 0}')"
      # echo "Found SECOND2=$SECOND2,so moving on..."

      MIN2=${CSVSTRING:110:2}
      MINUTE2="$(echo $MIN2 | awk '{print $1 + 0}')"
      # echo "Found MINUTE2=$MINUTE2,so moving on..."

      HR2=${CSVSTRING:107:2}
      HOUR2="$(echo $HR2 | awk '{print $1 + 0}')"
      # echo "Found HOUR2=$HOUR2,so moving on..."

      DY2=${CSVSTRING:104:2}
      DAY2="$(echo $DY2 | awk '{print $1 + 0}')"
      # echo "Found DAY2=$DAY2,so moving on..."

      MON2=${CSVSTRING:101:2}
      MONTH2="$(echo $MON2 | awk '{print $1 + 0}')"
      # echo "Found MONTH2=$MONTH2,so moving on..."

      YR2=${CSVSTRING:96:4}
      YEAR2="$(echo $YR2 | awk '{print $1 + 0}')"
      # echo "Found YEAR2=$YEAR2,so moving on..."

   fi

   #############################################################################################################
   # As of v12 (inherited from the scan.sh) we are going to collect and report the ESSID each client is actually attached to...
   #############################################################################################################
   ASSOCSSID=$(egrep -a $F1 $FILE1 | awk -v minus1="$NEGONE" -v mac="$F1" -F',' '$1==mac && $5!=minus1 && length($6)==18 {print $1, $2, $3, $4, $5, $6}' | awk '{ print $8 }')
   # ASSOCSSID=$(cat $FILE1 | grep -ai $F1 | awk -F, '{ print $6 }')
   # ASSOCSSID=$(awk -F, '{print $6}' $FILE1 | grep -ai $F1)
   ASSOCBSSID2=$(echo $ASSOCSSID | sed -e 's/^ *//' -e 's/^ *$//')
   ASSOCESSID2=$(cat $HOMEP/check_macs.txt | grep -ai $ASSOCBSSID2 | awk '{ print $2 }')
   if [ "$ASSOCESSID2" == "" ] ; then
      # echo "Our MAC = $F1 was not found in our custom database of known MACs..."
      ASSOCESSID2=$(cat $FILE1 | grep -m 1 -ai $ASSOCBSSID2 | awk -F, '{ print $14 }')
      # ASSOCESSID2=$(echo $ASSOCESSID2 | tr -d [:blank:])
      ASSOCESSID2=$(echo $ASSOCESSID2 | sed -e 's/^ *//' -e 's/^ *$//')
      # ASSOCESSID2=$ASSOCBSSID2
   fi
   if [ "$ASSOCESSID2" == " " ] ; then
      # echo "Our MAC = $F1 was not found in our custom database of known MACs nor was it captured correctly in the csv file..."
      ASSOCESSID2="hidden_ESSID"
   fi




   # ASSOCBSSID2=${ASSOCSSID:$ASSOCPREFIX:$ASSOCSUFFIX}
   ASSOCBSSID2LENGTH=${#ASSOCBSSID2}
   # echo "Found ASSOCBSSID2LENGTH = $ASSOCBSSID2LENGTH, so moving on..."

   #### The following if statement captures the fact that a client may have once associated to our AP,
   #### but now does not, and simply hangs out with WiFi turned on, but found to be (not associated) in .csv file.
   if [ "$ASSOCSSID" == "$NONASSOC" ] ; then
      ASSOCBSSID2LENGTH=0
   fi

   # if [ $MACAPPEARSTIMES -eq 0 ] ; then
   if (( ( $MACAPPEARSTIMES == 0 ) && ( $LOOPPASS >= 4 ) )) ; then
      echo "      Lost the MAC. He once was found but now is lost from the .csv file"
      echo "_LOST $(date +%a) $(date +%D) $(date +%T) $LOOPPASS $SCRIPTNAME $F2, OUI $MACSTRING, using $FILE1, by $HOSTNAME" >> $HOMEP/master_log.txt
      echo "_LOST $(date +%a) $(date +%D) $(date +%T) $LOOPPASS $SCRIPTNAME $F2, OUI $MACSTRING, using $FILE1, by $HOSTNAME" >> $SANDBOX/$F1"_history.txt"
      echo "_LOST $(date +%a) $(date +%D) $(date +%T) $LOOPPASS $SCRIPTNAME $F2, OUI $MACSTRING, using $FILE1, by $HOSTNAME" >> $SANDBOXAP/$ASSOCBSSID2"_history.txt"
      echo "_LOST $(date +%a) $(date +%D) $(date +%T) $LOOPPASS $SCRIPTNAME $F2, OUI $MACSTRING, using $FILE1, by $HOSTNAME"
      EVENTTYPE="LOST"
      if [ -e $SANDBOXNON/$F1"_history.txt" ] ; then
         echo "_LOST $(date +%a) $(date +%D) $(date +%T) $LOOPPASS $SCRIPTNAME $F2, OUI $MACSTRING, using $FILE1, by $HOSTNAME" >> $SANDBOXNON/$F1"_history.txt"
      fi
      SENDEMAILALERT
   fi

   if [ $LOOPPASS -gt 2 ] ; then
      echo -n "-sleep 2 more- "
      sleep 2
   fi

   if [ $LOOPPASS -gt 3 ] ; then
      echo "      Hanging, looping since cannot grab sane data"
      echo "_HUNG $(date +%a) $(date +%D) $(date +%T) $LOOPPASS $SCRIPTNAME $F1 $F2, OUI $MACSTRING, using $FILE1, by $HOSTNAME" >> $HOMEP/master_log.txt
      echo "_HUNG $(date +%a) $(date +%D) $(date +%T) $LOOPPASS $SCRIPTNAME $F1 $F2, OUI $MACSTRING, using $FILE1, by $HOSTNAME" >> $SANDBOX/$F1"_history.txt"
      echo "_HUNG $(date +%a) $(date +%D) $(date +%T) $LOOPPASS $SCRIPTNAME $F1 $F2, OUI $MACSTRING, using $FILE1, by $HOSTNAME" >> $SANDBOXAP/$ASSOCBSSID2"_history.txt"
      echo "_HUNG $(date +%a) $(date +%D) $(date +%T) $LOOPPASS $SCRIPTNAME $F1 $F2, OUI $MACSTRING, using $FILE1, by $HOSTNAME"
      EVENTTYPE="HUNG"
      if [ -e $SANDBOXNON/$F1"_history.txt" ] ; then
         echo "_HUNG $(date +%a) $(date +%D) $(date +%T) $LOOPPASS $SCRIPTNAME $F1 $F2, OUI $MACSTRING, using $FILE1, by $HOSTNAME" >> $SANDBOXNON/$F1"_history.txt"
      fi
      # SENDEMAILALERT
      LOOPPASS=0
      echo "+----------------------------------Debug Info----------------------------------------------------------------------------+"
      echo "SECOND1=$SECOND1, SECOND2=$SECOND2, MINUTE1=$MINUTE1, MINUTE2=$MINUTE2, HOUR1=$HOUR1, HOUR2=$HOUR2, DAY1=$DAY1, DAY2=$DAY2, MONTH1=$MONTH1, MONTH2=$MONTH2, YEAR1=$YEAR1, YEAR2=$YEAR2,"
      echo "ASSOCBSSID1LENGTH=$ASSOCBSSID1LENGTH, ASSOCBSSID2LENGTH=$ASSOCBSSID2LENGTH, ASSOCBSSID1=$ASSOCBSSID1, ASSOCBSSID2=$ASSOCBSSID2, ASSOCESSID1=$ASSOCESSID1, ASSOCESSID2=$ASSOCESSID2"
      echo "Not very relevant, but here you go --> DATE1LENGTH=$DATE1LENGTH, DATE2LENGTH=$DATE2LENGTH"
      echo "CSVSTRINGLENGTH=$CSVSTRINGLENGTH"
      echo "CSVSTRING=$CSVSTRING"
      echo "MACAPPEARSTIMES=$MACAPPEARSTIMES"
      echo "+------------------------------------------------------------------------------------------------------------------------+"
      MESSAGE="$SCRIPTNAME Sad for you ... $EVENTTYPE insane data still rules the day ... Looping at $HOSTNAME"
      # sendTEXTMESSAGE
      break
      # exit 0
   fi

   LASTSEENDATE="$YR2-$MON2-$DY2 $HR2:$MIN2:$SEC2"
   DATE2LENGTH=${#LASTSEENDATE}
   # echo "Found DATE2LENGTH= $DATE2LENGTH, so moving on..."

   # New code 6-Apr-2015 since on older BT4/BT5 distros a nested until loop seems wonky...
   getCURRENTDATE

   if [ $MACAPPEARSTIMES -gt 0 ] ; then
      ELAPSEDDAYS=$(dateDiff -d $LASTSEENDATE $CURRENTDATE)
      # echo "Elapsed days is $ELAPSEDDAYS, so moving on..."
   fi
   # echo -n "."
   let "LOOPPASS += 1"
done
#############################################################################################################
#############################################################################################################

if [ $LOOPPASS -gt 2 ] ; then
   echo "=Loop $(date +%a) $(date +%D) $(date +%T) $LOOPPASS $SCRIPTNAME $F2 $F1 at $SCRIPTNAME, OUI $MACSTRING, using $FILE1, by $HOSTNAME" >> $HOMEP/master_log.txt
   echo "=Loop $(date +%a) $(date +%D) $(date +%T) $LOOPPASS $SCRIPTNAME $F2 $F1 at $SCRIPTNAME, OUI $MACSTRING, using $FILE1, by $HOSTNAME" >> $SANDBOX/$F1"_history.txt"
   echo "=Loop $(date +%a) $(date +%D) $(date +%T) $LOOPPASS $SCRIPTNAME $F2 $F1 at $SCRIPTNAME, OUI $MACSTRING, using $FILE1, by $HOSTNAME" >> $SANDBOXAP/$ASSOCBSSID2"_history.txt"
   echo "=Loop $(date +%a) $(date +%D) $(date +%T) $LOOPPASS $F2 at $SCRIPTNAME, OUI $MACSTRING, using $FILE1, by $HOSTNAME"
fi
# echo -n "$LOOPPASS loops"

# First read the Legacy Date in case we need it...
LEGACYDATE=$(cat $SANDBOX/$F1"_last_seen.txt")
LASTSEENEXISTS=$(echo $?)

ELAPSEDMINS=$(dateDiff -m $LASTSEENDATE $CURRENTDATE)
ELAPSEDHOURS=$(dateDiff -h $LASTSEENDATE $CURRENTDATE)
ELAPSEDDAYS=$(dateDiff -d $LASTSEENDATE $CURRENTDATE)
MODMINUTE=$(($ELAPSEDMINS % 60))
MODHOURS=$(($ELAPSEDHOURS % 24))

# Now save off the last seen date in our new sandbox...
echo $LASTSEENDATE > $SANDBOX/$F1"_last_seen.txt"
# Below line added 9-Apr-2015 to keep attv2 and testv12 scripts from stepping on one another...
echo $LASTSEENDATE > $SANDBOX/$F1"_test_last_seen.txt"
# Below line added 11-Apr-2015 to keep attv2 and nonv6 scripts in sync with on one another...
echo $LASTSEENDATE > $SANDBOXNON/$F1"_test_last_seen.txt"

# Also capture the BSSID client was last attached to, and also write the current BSSID attached to...
PREVASSOCMAC=$(cat $SANDBOX/$F1"_mac_attached_to.txt")
# Next write a marker file in sandbox containing the MAC addy of the AP this client was found associated to:
echo $ASSOCBSSID1 > $SANDBOX/$F1"_mac_attached_to.txt"

# PREVIOUSMINS=$(cat $SANDBOX/$F1"_last_seen.txt")
# echo "Let it be said that _last_seen.txt variable is: $PREVIOUSMINS"
# sleep 1
# echo $ELAPSEDMINS > $SANDBOX/$F1"_last_seen.txt"

echo "$SCRIPTNAME .. $ELAPSEDDAYS$DAY $MODHOURS$HOUR $MODMINUTE$MIN ($ELAPSEDMINS$MIN) since $F1 <=> $MACSTRING <=> $F2 ($ASSOCESSID2) Fresh = $CLIENTMARKER"
# echo "At $SCRIPTNAME .. $ELAPSEDDAYS d, $MODHOURS h, $MODMINUTE m, $ELAPSEDMINS elapsed, $POWER pow, $DATA data, since $F1 <=> $MACSTRING <=> $F2"
# echo "At $SCRIPTNAME .. $ELAPSEDDAYS d, $MODHOURS h, $MODMINUTE m, $ELAPSEDMINS elapsed, $POWER pow, $DATA data, since $F1 <=> $MACSTRING <=> $F2" >> log.txt
echo "$SCRIPTNAME .. $ELAPSEDDAYS$DAY $MODHOURS$HOUR $MODMINUTE$MIN ($ELAPSEDMINS$MIN) since $F1 <=> $MACSTRING <=> $F2 ($ASSOCESSID2) Fresh = $CLIENTMARKER" >> log.txt

# Added 6-Feb-2013 to stop collecting, reporting bad data
   if [ $ELAPSEDDAYS -gt 999 ] ; then
      echo "      Insane Data detected, so bye bye"
      echo "_BADD $(date +%a) $(date +%D) $(date +%T) _ $SCRIPTNAME $F2, OUI $MACSTRING, using $FILE1, by $HOSTNAME" >> $HOMEP/master_log.txt
      echo "_BADD $(date +%a) $(date +%D) $(date +%T) _ $SCRIPTNAME $F2, OUI $MACSTRING, using $FILE1, by $HOSTNAME" >> $SANDBOX/$F1"_history.txt"
      echo "_BADD $(date +%a) $(date +%D) $(date +%T) _ $SCRIPTNAME $F2, OUI $MACSTRING, using $FILE1, by $HOSTNAME" >> $SANDBOXAP/$ASSOCBSSID2"_history.txt"
      echo "_BADD $(date +%a) $(date +%D) $(date +%T) _ $SCRIPTNAME $F2, OUI $MACSTRING, using $FILE1, by $HOSTNAME"
      EVENTTYPE="BADD"
      if [ -e $SANDBOXNON/$F1"_history.txt" ] ; then
         echo "_BADD $(date +%a) $(date +%D) $(date +%T) _ $SCRIPTNAME $F2, OUI $MACSTRING, using $FILE1, by $HOSTNAME" >> $SANDBOXNON/$F1"_history.txt"
      fi
      SENDEMAILALERT
      LOOPPASS=0
      # exit 0
   fi

############## New Arrvial Code Section #############################################
# Below are the sections written to trigger leave and arrival alerts of our MAC client
#####################################################################################
# First, test if the client is brand new to the AP, if so, send e-mail...
#------------------------------------------------------------------------------------
# if [ "$CLIENTMARKER" == "" ] ; then
if [ $LASTSEENEXISTS -eq 1 ] ; then
   echo "...$F2 Newly arrived."
   # echo "...$F2 Newly arrived." >> log.txt
   echo "1" > $SANDBOX/$F1"_is_fresh.txt"
   # Ok, so brand new mobile just arrived at the AP, so...
   EVENTTYPE="Newly-Arrived"
   echo "1" > $SANDBOX/$F1"_is_fresh.txt"
   SHORTMAC=${F1:0:8}
   MACSTRING=$(cat $HOMEP/oui_custom.txt | grep -i $SHORTMAC | awk '{ print $2" "$3" "$4" "$5" "$6" "$7}' | sed -e 's/[[:space:]]*$//')
   if [ "$MACSTRING" == "" ] ; then
      # echo "Our MAC = $F1 was not found in the custom OUI database..."
      # MACSTRING=$F1"_unkOUI"
      MACSTRING=${F1:0:8}"_unkOUI"
      # echo "So we will use $MACSTRING for the OUI descriptor."
   fi
   # CLIENTMARKER=1

   #  MACAPPEARSTIMES=1

   SEC2=${CSVSTRING:35:2}
   SECOND2="$(echo $SEC2 | awk '{print $1 + 0}')"
   # echo "Found SECOND2=$SECOND2,so moving on..."

   MIN2=${CSVSTRING:32:2}
   MINUTE2="$(echo $MIN2 | awk '{print $1 + 0}')"
   # echo "Found MINUTE2=$MINUTE2,so moving on..."

   HR2=${CSVSTRING:29:2}
   HOUR2="$(echo $HR2 | awk '{print $1 + 0}')"
   # echo "Found HOUR2=$HOUR2,so moving on..."

   DY2=${CSVSTRING:26:2}
   DAY2="$(echo $DY2 | awk '{print $1 + 0}')"
   # echo "Found DAY2=$DAY2,so moving on..."

   MON2=${CSVSTRING:23:2}
   MONTH2="$(echo $MON2 | awk '{print $1 + 0}')"
   # echo "Found MONTH2=$MONTH2,so moving on..."

   YR2=${CSVSTRING:18:4}
   YEAR2="$(echo $YR2 | awk '{print $1 + 0}')"

   until [ "$PROBES1" == "$PROBES2" ] ; do
      PROBES1=$(egrep -ai $F1 $FILE1 | awk -F, '{ print $7","$8","$9","$10","$11}')
      PROBES1=$(echo $PROBES1 | tr -d [:cntrl:])
      # PROBES1=$(awk -F, '{ print $7 $8 $9 $10 $11 }' $FILE1 | grep -ai $F1)
      # usleep 250000
      sleep 1
      PROBES2=$(egrep -ai $F1 $FILE1 | awk -F, '{ print $7","$8","$9","$10","$11}')
      PROBES2=$(echo $PROBES2 | tr -d [:cntrl:])
      # PROBES2=$(awk -F, '{ print $7 $8 $9 $10 $11 }' $FILE1 | grep -ai $F1)
   done

   SENDEMAILALERT

   echo "+New+ $(date +%a) $(date +%D) $(date +%T) + $SCRIPTNAME $F2, OUI $MACSTRING, first seen $MONTH2/$DAY2/$YEAR2 $HR2:$MIN2:$SEC2, latched '($ASSOCESSID2)' by $HOSTNAME"
   echo "+New+ $(date +%a) $(date +%D) $(date +%T) + $SCRIPTNAME $F2 $F1 OUI $MACSTRING, first seen $MONTH2/$DAY2/$YEAR2 $HR2:$MIN2:$SEC2, latched '($ASSOCESSID2)' by $HOSTNAME" >> $HOMEP/master_log.txt
   echo "+New+ $(date +%a) $(date +%D) $(date +%T) + $SCRIPTNAME $F2 $F1 OUI $MACSTRING, first seen $MONTH2/$DAY2/$YEAR2 $HR2:$MIN2:$SEC2, latched '($ASSOCESSID2)' by $HOSTNAME" >> $SANDBOX/$F1"_history.txt"
   echo "+New+ $(date +%a) $(date +%D) $(date +%T) + $SCRIPTNAME $F2 $F1 OUI $MACSTRING, first seen $MONTH2/$DAY2/$YEAR2 $HR2:$MIN2:$SEC2, latched '($ASSOCESSID2)' by $HOSTNAME" >> $SANDBOXAP/$ASSOCBSSID2"_history.txt"
   echo "$EVENTTYPE $F2 to $ASSOCESSID2 OUI $MACSTRING first seen $MONTH2-$DAY2-$YEAR2 $HOUR2:$MINUTE2:$SECOND2, by $HOSTNAME"
   if [ -e $SANDBOXNON/$F1"_history.txt" ] ; then
      echo "+New+ $(date +%a) $(date +%D) $(date +%T) + $SCRIPTNAME $F2 $F1 OUI $MACSTRING, first seen $MONTH2/$DAY2/$YEAR2 $HR2:$MIN2:$SEC2, latched '($ASSOCESSID2)' by $HOSTNAME" >> $SANDBOXNON/$F1"_history.txt"
   fi
fi

############## Set CLIENTMARKER and _is_fresh.txt section ###########################
#####################################################################################
#------------------------------------------------------------------------------------
# if [ $FIRSTPASS1YES0NO -eq 0 ] ; then
   if [ $ELAPSEDMINS -gt $QUIETTHRESH ] ; then
      if [ $CLIENTMARKER -eq 1 ] ; then
         # echo "ZERO out all the _is_fresh.txt files, then proceed..."
         echo "0" > $SANDBOX/$F1"_is_fresh.txt"
         # CLIENTMARKER=0
         EVENTTYPE="Gone"
         # echo "$EVENTTYPE $F2 from $SCRIPTNAME OUI $MACSTRING $(date +%D) $(date +%T) thrsh $QUIETTHRESH m, elapsed $ELAPSEDMINS m, by $HOSTNAME"
         echo "-Gone $(date +%a) $(date +%D) $(date +%T) - $SCRIPTNAME ($ASSOCESSID2) $F2 OUI $MACSTRING last seen $LEGACYDATE, elapsed $ELAPSEDMINS using $FILE1, by $HOSTNAME"
         echo "-Gone $(date +%a) $(date +%D) $(date +%T) - $SCRIPTNAME ($ASSOCESSID2) $F2 $F1 OUI $MACSTRING last seen $LEGACYDATE, elapsed $ELAPSEDMINS using $FILE1, by $HOSTNAME" >> $HOMEP/master_log.txt
         echo "-Gone $(date +%a) $(date +%D) $(date +%T) - $SCRIPTNAME ($ASSOCESSID2) $F2 $F1 OUI $MACSTRING last seen $LEGACYDATE, elapsed $ELAPSEDMINS using $FILE1, by $HOSTNAME" >> $SANDBOX/$F1"_history.txt"
         echo "-Gone $(date +%a) $(date +%D) $(date +%T) - $SCRIPTNAME ($ASSOCESSID2) $F2 $F1 OUI $MACSTRING last seen $LEGACYDATE, elapsed $ELAPSEDMINS using $FILE1, by $HOSTNAME" >> $SANDBOXAP/$ASSOCBSSID2"_history.txt"
         if [ -e $SANDBOXNON/$F1"_history.txt" ] ; then
            echo "-Gone $(date +%a) $(date +%D) $(date +%T) - $SCRIPTNAME ($ASSOCESSID2) $F2 $F1 OUI $MACSTRING, last seen $LEGACYDATE, elapsed $ELAPSEDMINS using $FILE1, by $HOSTNAME" >> $SANDBOXNON/$F1"_history.txt"
         fi
         SENDEMAILALERT
      fi
   fi

   # Added below if clause 28-Nov-2015 to keep newly-arrived from triggering back log reporting...
   if [ "$EVENTTYPE" != "Newly-Arrived" ] ; then
      if [ $ELAPSEDMINS -lt $QUIETTHRESH ] ; then
         # Following condition commented out 28-Aug-2015 since when a new csvfile is begun, certain clients return events are not detected.
         if [[ $CLIENTMARKER -eq $ZERO ]] ; then
            # Added 6-Feb-2013 to stop collecting, reporting bad data
            if [ $ELAPSEDDAYS -lt 1825 ] ; then # 1825 is approximately 5 years
               # echo "One out all the _is_fresh.txt files, then proceed..."
               echo "1" > $SANDBOX/$F1"_is_fresh.txt"
               # CLIENTMARKER=1
               EVENTTYPE="Back"

               LEGACYMINS=$(dateDiff -m $LEGACYDATE $CURRENTDATE)
               LEGACYHOURS=$(dateDiff -h $LEGACYDATE $CURRENTDATE)
               LEGACYDAYS=$(dateDiff -d $LEGACYDATE $CURRENTDATE)

               LEGACYMODMINS=$(($LEGACYMINS % 60))
                  LEGACYMODHOURS=$(($LEGACYHOURS % 24))
      
               # echo "$EVENTTYPE $SCRIPTNAME ($ASSOCESSID2) $F2 OUI $MACSTRING $(date +%D) $(date +%T), last seen $LEGACYDAYS d, $LEGACYMODHOURS h, $LEGACYMODMINS m ago by $HOSTNAME"
               echo "+Back $(date +%a) $(date +%D) $(date +%T) + $SCRIPTNAME ($ASSOCESSID2) $F2 OUI $MACSTRING last seen $LEGACYDAYS d, $LEGACYMODHOURS h, $LEGACYMODMINS m ago, using $FILE1, by $HOSTNAME"
               echo "+Back $(date +%a) $(date +%D) $(date +%T) + $SCRIPTNAME ($ASSOCESSID2) $F2 $F1 OUI $MACSTRING last seen $LEGACYDAYS d, $LEGACYMODHOURS h, $LEGACYMODMINS m ago using $FILE1 $HOSTNAME" >> $HOMEP/master_log.txt
               echo "+Back $(date +%a) $(date +%D) $(date +%T) + $SCRIPTNAME ($ASSOCESSID2) $F2 $F1 OUI $MACSTRING last seen $LEGACYDAYS d, $LEGACYMODHOURS h, $LEGACYMODMINS m ago using $FILE1 $HOSTNAME" >> $SANDBOX/$F1"_history.txt"
               echo "+Back $(date +%a) $(date +%D) $(date +%T) + $SCRIPTNAME ($ASSOCESSID2) $F2 $F1 OUI $MACSTRING last seen $LEGACYDAYS d, $LEGACYMODHOURS h, $LEGACYMODMINS m ago using $FILE1 $HOSTNAME" >> $SANDBOXAP/$ASSOCBSSID2"_history.txt"
               if [ -e $SANDBOXNON/$F1"_history.txt" ] ; then
                  echo "+Back $(date +%a) $(date +%D) $(date +%T) + $SCRIPTNAME ($ASSOCESSID2) $F2 $F1 OUI $MACSTRING last seen $LEGACYDAYS d, $LEGACYMODHOURS h, $LEGACYMODMINS m ago using $FILE1 $HOSTNAME" >> $SANDBOXNON/$F1"_history.txt"
               fi
               SENDEMAILALERT
            fi
         fi
      fi
   fi
# fi

############## Detect Roamer away and here code section #############################
#####################################################################################
#------------------------------------------------------------------------------------

# Also pull the last known AP MAC address the client was attached to...
# PREVASSOCMAC=$(cat $SANDBOX/$F1"_mac_attached_to.txt")

if [ "$PREVASSOCMAC" != "" ] ; then
   if [ "$PREVASSOCMAC" != "$ASSOCBSSID2" ] ; then
   # Following line added 16-Oct-2015 since still seeing some false positives in the Roamed-Here reports...
   # if [ "$PREVASSOCMAC" != "$ASSOCESSID2" ] ; then
      # This condition met means previous record of client attachment has changed
      # PREVASSOCMACNAME=$(cat $HOMEP/check_macs.txt | grep -i $PREVASSOCMAC | awk '{ print $2 }')
      PREVASSOCMACNAME=$(egrep -i $PREVASSOCMAC $HOMEP/check_macs.txt | awk '{ print $2 }')
      echo $ASSOCBSSID2 > $SANDBOX/$F1"_mac_attached_to.txt"
      ASSOCESSID2=$(egrep -i $ASSOCBSSID2 $HOMEP/check_macs.txt | awk '{ print $2 }')
      if [ "$ASSOCESSID2" == "" ] ; then
         ASSOCESSID2=$(cat $FILE1 | grep -m 1 -ai $ASSOCBSSID2 | awk -F, '{ print $14 }')
      fi
      # PREVASSOCMACNAME=$(echo $ASSOCESSID2 | sed -e 's/^ *//' -e 's/^ *$//')
      ASSOCESSID2=$(echo $ASSOCESSID2 | sed -e 's/^ *//' -e 's/^ *$//')
      if ( [ "$PREVASSOCMACNAME" == "" ] && [ -e $SANDBOXAP/$PREVASSOCMAC"_current_essid.txt" ] ) ; then
         echo "Our MAC = $F1 does exist in the sandbox-ap file..."
         # Quash the bug below!
         # PREVASSOCMACNAME=$HOMEP/$SANDBOXAP/$PREVASSOCMAC"_current_essid.txt"
         PREVASSOCMACNAME=$(cat $SANDBOXAP/$PREVASSOCMAC"_current_essid.txt")
      fi
      if [ "$PREVASSOCMACNAME" == "" ] ; then
         echo "Our MAC = $F1 was not found in our custom database of known MACs, nor in the sandbox-ap file..."
         PREVASSOCMACNAME=$PREVASSOCMAC"_unkMAC"
      fi
      EVENTTYPE="Roamed-Here"
      echo "+ROAM $(date +%a) $(date +%D) $(date +%T) + $SCRIPTNAME ($ASSOCESSID2) << $F2 << ($PREVASSOCMACNAME) $F1 OUI $MACSTRING Roamed, $FILE1 $HOSTNAME" >> $HOMEP/master_log.txt
      # echo "+ROAM $(date +%a) $(date +%D) $(date +%T) + $SCRIPTNAME ($ASSOCESSID2) $F2 $F1 OUI $MACSTRING These two should be dissimilar: from: ($PREVASSOCMAC) and To: ($ASSOCBSSID2)" >> $HOMEP/master_log.txt
      echo "+ROAM $(date +%a) $(date +%D) $(date +%T) + $SCRIPTNAME ($ASSOCESSID2) << $F2 << ($PREVASSOCMACNAME) $F1 OUI $MACSTRING Roamed, $FILE1 $HOSTNAME" >> $SANDBOX/$F1"_history.txt"
      echo "+ROAM $(date +%a) $(date +%D) $(date +%T) + $SCRIPTNAME ($ASSOCESSID2) << $F2 << ($PREVASSOCMACNAME) $F1 OUI $MACSTRING Roamed, $FILE1 $HOSTNAME" >> $SANDBOXAP/$ASSOCBSSID2"_history.txt"
      echo "+ROAM $(date +%a) $(date +%D) $(date +%T) + $SCRIPTNAME ($ASSOCESSID2) << $F2 << ($PREVASSOCMACNAME) $F1 OUI $MACSTRING Roamed, $FILE1 $HOSTNAME" >> $SANDBOXAP/$PREVASSOCMAC"_history.txt"

      # echo "+ROAM $(date +%a) $(date +%D) $(date +%T) + $SCRIPTNAME ($ASSOCESSID2) $F2 $F1 OUI $MACSTRING Roamed To $ASSOCESSID2 from $PREVASSOCMACNAME, $FILE1 $HOSTNAME" >> $SANDBOX/$F1"_history.txt"
      # echo "+ROAM $(date +%a) $(date +%D) $(date +%T) + $SCRIPTNAME ($ASSOCESSID2) $F2 $F1 OUI $MACSTRING Roamed To $ASSOCESSID2 from $PREVASSOCMACNAME, $FILE1 $HOSTNAME" >> $SANDBOXAP/$ASSOCBSSID2"_history.txt"
      # echo "+ROAM $(date +%a) $(date +%D) $(date +%T) + $SCRIPTNAME ($ASSOCESSID2) $F2 $F1 OUI $MACSTRING Roamed To $ASSOCESSID2 from $PREVASSOCMACNAME, $FILE1 $HOSTNAME" >> $SANDBOXAP/$PREVASSOCMAC"_history.txt"
      if [ -e $SANDBOXNON/$F1"_history.txt" ] ; then
         echo "+ROAM $(date +%a) $(date +%D) $(date +%T) + $SCRIPTNAME ($ASSOCESSID2) << $F2 << ($PREVASSOCMACNAME) $F1 OUI $MACSTRING Roamed, $FILE1 $HOSTNAME" >> $SANDBOXNON/$F1"_history.txt"
         # echo "+ROAM $(date +%a) $(date +%D) $(date +%T) + $SCRIPTNAME ($ASSOCESSID2) $F2 $F1 OUI $MACSTRING Roamed To $ASSOCESSID2 from $PREVASSOCMACNAME, $FILE1 $HOSTNAME" >> $SANDBOXNON/$F1"_history.txt"
      fi
      SENDEMAILALERT
   fi
fi
}
##############################
### Main script stars here ###
##############################

declare -i LEGACYDAYS
declare -i LEGACYMINS
declare -i LEGACYMODHOURS
declare -i LEGACYMODMINS
declare -i SECOND1
declare -i MINUTE1
declare -i HOUR1
declare -i DAY1
declare -i MONTH1
declare -i YEAR1
declare -i SECOND2
declare -i MINUTE2
declare -i HOUR2
declare -i DAY2
declare -i MONTH2
declare -i YEAR2
# declare -i INTERDELAY
# declare -i INTRADELAY
declare -i UNKNOWNMAC

FIRSTPASS1YES0NO=1
FIRSTPASS=1
HOMEP=.
UNKNOWNOUIFILE=$HOMEP/unkOUI.txt
MINUTES6480=6480 # 6480 minutes is exactly 4.5 days

while [ -e ./go ] ; do
   HOMEP=.
   if [ $FIRSTPASS -eq 0 ] ; then 
      INTERDELAY=$(cat $HOMEP/interdelay.txt)
      INTRADELAY=$(cat $HOMEP/intradelay.txt)
   else 
      INTERDELAY=1
      INTRADELAY=1
   fi   

   LOOPPASS=0
   ZERO=0
   FILE1=$1
   SANDBOX=$HOMEP/sandbox
   SANDBOXNON=$HOMEP/sandbox-non
   SANDBOXAP=$HOMEP/sandbox-ap
   MINUTE1=-1 ; HOUR1=-1 ; DAY1=-1 ; MONTH1=-1 ; YEAR1=-1
   MINUTE2=1  ; HOUR2=1  ; DAY2=1  ; MONTH2=1  ; YEAR2=1
   MINUTETHRESH15=0
   PREVIOUSMINS=1
   TEMPMINS=-1
   MODMINUTE=0
   MODHOUR=0
   THRESH=-1
   ELAPSEDMINS=-1
   THRESHEXCEEDALERTED=-1
   QUIETTHRESH=59
   WEEDOUTTHRESH=80
   MESSAGE="undefined"
   EVENTTYPE="undefined"
   ASSOC="assoc"
   # SSID=`basename $0`
   SSID=${0##*/}
   # SCRIPTNAME=(attv1)
   SCRIPTNAME=${0##*/}
   UNKNOWNMAC=10
   CKSUM1=1
   CKSUM2=1
   DAY=d
   MIN=m
   HOUR=h
   FILESIZE1=-1
   FILESIZE2=-2
   MODFILESIZE1=-1
   MODFILESIZE2=-2
   LINEVAR="att_line.txt"
   # MACATTACHEDTO="00:11:22:33:44:55"
   PREVASSOCMAC="66:77:88:99:AA:BB"
   CLIENTNONHISTORY="Init History"

   # 7-Nov-2014:
   # This variable BLACKLISTEDAPMAC is set to the AP who thinks his clients should scramble their MAC addrresses to avoid being pinned down.
   # While not the ideal way to handle things, it is a good start in ignoring the static introduced by such bad behaviour.
   # And by static I mean about 147 distinct, yet random, client MAC addresses in the attached list.
   BLACKLISTEDAPMAC="00:25:00:FF:94:73"
   #
   # 11-Nov-2014:
   # Modified the approach slightly... Now we keep the black listed MACs in their own file. This allows the grep -vf command to parse the
   # file's contents and act based on what it finds inside. Just a bit more flexibility built in.
   # BLACKLISTEDAPMACLIST=$HOMEP/ap_exempt_list.txt

   # Build the initial file that lists all the MACs found attached to the target AP...
   # The following rm line added 18-Sep-2014 since the .csv file can sometimes lose
   # track of non-associated clients that once appeared there.
   rm $SANDBOX/"$ASSOC".txt
   echo "Time to build up list of MACs we see are attached to the APs nearby."
   until [[ CKSUM1 -ne CKSUM2 ]] ; do
      # With this loop, we watch the csvfile for the moment AFTER it changes. That moment is when the check sums DO NOT match.
      # Theory is when check sums DO NOT match we wait for 1 more second and the csvfile should NOT be dynamically changing.
      # The end result of all this is more reliable detection of attached clients, no misses.
      CKSUM1=$(cksum $FILE1 | awk '{ print $1 }')
      sleep 0.350000
      CKSUM2=$(cksum $FILE1 | awk '{ print $1 }')
      sleep 0.350000
      echo -n "-"
   done

   echo "-"
   sleep 1

   CKSUM1=1
   CKSUM2=2
      
   until ( [[ CKSUM1 -eq CKSUM2 ]] && [[ MODFILESIZE1 -eq ZERO ]] && [[ MODFILESIZE2 -eq ZERO ]] ); do
      echo -n "."
      # cat $FILE1 | awk -F, '{ print $6 }' | grep -o -E '([[:xdigit:]]{1,2}:){5}[[:xdigit:]]{1,2}' > $SANDBOX/"$ASSOC"_attached.txt
      # cat $FILE1 | awk -F, '{ print $1, $6 }' | grep -vf $BLACKLISTEDAPMACLIST | awk 'length($2)==17 { print $1 }' | sort -u > $SANDBOX/"$ASSOC"_attached.txt
      cat $FILE1 | awk -F, '{ print $1 $3 $6 }' | grep -v $BLACKLISTEDAPMAC | awk 'length($4)==17 { print $1, $2, $3 }' | sort -u > $SANDBOX/"$ASSOC"_attached.txt
      # cat $FILE1 | grep -ai associated | awk -F, '{ print $1 }' > $SANDBOX/"$ASSOC"_attached.txt
      CKSUM1=$(cksum $SANDBOX/"$ASSOC"_attached.txt | awk '{ print $1 }')
      # echo "Cksum-1 is $CKSUM1, so onward..."
      FILESIZE1=$(stat --printf="%s" $SANDBOX/"$ASSOC"_attached.txt)
      MODFILESIZE1=$((FILESIZE1 % 38))
      # echo "FILESIZE1 is $FILESIZE1, so onward..."
      # echo "MODFILESIZE1 is $MODFILESIZE1, so onward..."

      # usleep 500000
      sleep 0.500

      # cat $FILE1 | awk -F, '{ print $6 }' | grep -o -E '([[:xdigit:]]{1,2}:){5}[[:xdigit:]]{1,2}' > $SANDBOX/"$ASSOC"_attached.txt
      # cat $FILE1 | awk -F, '{ print $1, $6 }' | grep -vf $BLACKLISTEDAPMACLIST | awk 'length($2)==17 { print $1 }' | sort -u > $SANDBOX/"$ASSOC"_attached.txt
      cat $FILE1 | awk -F, '{ print $1 $3 $6 }' | grep -v $BLACKLISTEDAPMAC | awk 'length($4)==17 { print $1, $2, $3 }' | sort -u > $SANDBOX/"$ASSOC"_attached.txt
      # cat $FILE1 | grep -ai associated | awk -F, '{ print $1 }' > $SANDBOX/"$ASSOC"_attached.txt
      CKSUM2=$(cksum $SANDBOX/"$ASSOC"_attached.txt | awk '{ print $1 }')
      # echo "Cksum-2 is $CKSUM2, so onward..."
      FILESIZE2=$(stat --printf="%s" $SANDBOX/"$ASSOC"_attached.txt)
      MODFILESIZE2=$((FILESIZE2 % 38))
      # echo "FILESIZE2 is $FILESIZE2, so onward..."
      # echo "MODFILESIZE2 is $MODFILESIZE2, so onward..."

      # usleep 250000
      sleep 0.500
   done

#### The new loop below attempts to filter out non clients older than, say, 3 hours...
   echo "About to perform the weedout process, hang on..."
   # Set loop separator to end of line 
   getCURRENTDATE
   RAWASSOCFILE=$SANDBOX/"$ASSOC"_attached.txt
   BAKIFS=$IFS
   IFS=$(echo -en "\n\b") 
   exec 3<&0
   exec 0<"$RAWASSOCFILE"
   while read -r line 
   do
      # echo -n "*** Current LINE: $line"
      # use $line variable to process line in processLine() function
      weedOutLine $line
      # sleep $INTRADELAY
      # echo -n "-"
   done
   exec 0<&3
   # restore $IFS which was used to determine what the field separators are
   IFS=$BAKIFS

   sleep 2

   echo "" 
   echo "Ok, just completed weedout process. Just found $(cat $SANDBOX/"$ASSOC".txt | wc -l) fresh attachers, out of $(cat $SANDBOX/"$ASSOC"_attached.txt | wc -l) total."

   # cat $SANDBOX/"$ASSOC"_attached.txt >> $SANDBOX/"$ASSOC".txt
   # cat $SANDBOX/"$ASSOC".txt | sort -uo $SANDBOX/"$ASSOC".txt

   # cat $SANDBOX/"$ASSOC"_attached.txt | sort -uo $SANDBOX/"$ASSOC"_attached.txt

   echo -n " " >> $SANDBOX/$LINEVAR
   echo -n "(" >> $SANDBOX/$LINEVAR
   echo -n $(cat $SANDBOX/"$ASSOC".txt | wc -l) >> $SANDBOX/$LINEVAR
   echo -n "," >> $SANDBOX/$LINEVAR
   echo -n $(cat $SANDBOX/"$ASSOC"_attached.txt | wc -l) >> $SANDBOX/$LINEVAR
   echo -n ")" >> $SANDBOX/$LINEVAR


   # echo -n $(cat $SANDBOX/"$ASSOC"_attached.txt | wc -l) >> $SANDBOX/$LINEVAR
   # echo -n "," >> $SANDBOX/$LINEVAR

   echo ""
   echo "Just wrote you a nice _attached.txt file, so go check it Mkay?"
   echo "-------------------------------------------------------------------------------------------"
   ls -alrt $SANDBOX/$ASSOC*.txt
   echo "--- Check-Sum of the _attached file is: $CKSUM1, so moving on..."
   echo "****** $ASSOC ** $SCRIPTNAME ** Inter delay=$INTERDELAY, intra delay=$INTRADELAY **"
   echo "$(cat $SANDBOX/"$ASSOC".txt | wc -l) / $(cat $SANDBOX/"$ASSOC"_attached.txt | wc -l) clients discovered in this run, weed out threshold is $WEEDOUTTHRESH$MIN."
   echo "-------------------------------------------------------------------------------------------"

   FILE=$SANDBOX/"$ASSOC".txt
   if [ -e $HOMEP/full ] ; then
      FILE=$SANDBOX/"$ASSOC"_attached.txt
      echo "******************************************* Despite Weedout algorithm, detected ./full so we will check all MACs *******************************************"
   fi
   # FILE=$SANDBOX/"$ASSOC"_attached.txt
   # read $FILE using the file descriptors
   # FILE is defined by the newest freshest MACs found in the .csv file.
   # Set loop separator to end of line
   BAKIFS=$IFS
   IFS=$(echo -en "\n\b")
   exec 3<&0
   exec 0<"$FILE"
   while read -r line
   do
      # echo -n "*** Current LINE: $line"
      # use $line variable to process line in processLine() function
      processLine $line
      sleep $INTRADELAY
      echo " "
   done
   exec 0<&3
   # restore $IFS which was used to determine what the field separators are
   IFS=$BAKIFS

   echo "****** $CURRENTDATE *****************************************************"
   ls -alrt $SANDBOX/$ASSOC*.txt
   echo "****** $ASSOC ** $SCRIPTNAME ** Inter delay=$INTERDELAY, intra delay=$INTRADELAY *************"
   # echo "****** $CURRENTDATE *****************************************************"
   echo ''
   echo "NOTE: If you wish that this script bypasses the weed-out file, and want the full monty, simply: touch full"
   echo ''
   echo ''
   # echo "Current date is ... $(date '+%Y') $(date '+%m') $(date '+%d') $(date '+%H') $(date '+%M') $(date '+%S')" >> log.txt
   FIRSTPASS1YES0NO=0
   sleep $INTERDELAY
   INTERDELAY=$(cat $HOMEP/interdelay.txt)
   INTRADELAY=$(cat $HOMEP/intradelay.txt)
   FIRSTPASS=0
   CHECKFORPAUSE
   CHECKFORSTOP
done
exit 0
