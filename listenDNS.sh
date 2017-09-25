#!/bin/bash
  
MyIP=192.168.0.3
EMAIL=unixadm@delepine.org

true
while [ $? == 0 ] ; do
  [ "$?" != "0" ] && exit
  tcpdump -n -l  udp dst port 53 and dst host $MyIP 2>/dev/null | grep -m 1 ALERTE \
    | sed 's/.*ALERTE\.\([^\.]*\)\.\(.*\)\.FINMSG.*/\1 \2/g;s/-/ /g' \
    | while read CLIENT MSG; do
      [ "$(</tmp/LastMSG)" != "$CLIENT$MSG" ] \
      && echo $CLIENT$MSG >/tmp/LastMSG \
      && echo $MSG | base64 -d |mail -s "Alerte $( echo $CLIENT | base64 -d )" $EMAIL
      # mail, or whatever in order to send notif...
      sleep 2
    done
done
