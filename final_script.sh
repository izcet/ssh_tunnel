#!/bin/sh

SITE=pirated.space
USER=root
PO=57184
PI=57182

#Proxy Open is the port to connect to the proxy server to initialize
#Proxy Port is the port for the remote to connect to the proxy to be forwarded
PP=57183

LIST=/.portlist

while [ 1 ] ; do

	# Cycle through different active ports
	PORT=$(head -1 $LIST)
	sed -i 1,0d $LIST
	echo "$PORT" >> $LIST

	# Maintain the connection without input
	KEEPALIVE="while true ; do sleep 500 ; done"

	# Open the port forward from the proxy listen to the redirect port
	CMD="lsof -ti:$PP | xargs kill -9 ; echo $PORT > /.activeport ; ssh -N $USER@localhost -p $PO -L *:$PP:localhost:$PORT -o TCPKeepAlive=yes"

	# Open the port forward from this host to the proxy redirect
	ssh -R $PORT:localhost:57183 $USER@$SITE -p $PO "$CMD"
	sleep 3
done
