#!/bin/bash

# DO NOT TOUCH THIS

CURR=/.portcurrent
LIST=/.portlist
while [ 1 ] ; do
	PORT=$(head -1 $LIST)
	sed -i 1,0d $LIST
	echo "$PORT" >> $LIST
	echo "$PORT" > $CURR
	scp -P 57183 $CURR root@pirated.space:/.activeport
	ssh -R $PORT:localhost:57183 root@pirated.space -p 57183 'sh keepalive.sh'
	sleep 3
done
