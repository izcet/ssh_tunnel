#!/bin/sh

# PP (Proxy Open) is the port to connect to the proxy server to initialize
# PP (Proxy Port) is the port for the remote to connect to the proxy to be forwarded
# LP (Local Port) is the port that localhost listens to for sshd connections
# PI (Port Intermediary) is the port that the proxy uses to connect the port forwards

SITE=""
USER=""
PO=""
PP=""
LP=""
PI=""

# Part One establishes the "reverse tunnel" (allowing connections back to this machine)

# Part Two establishes the port forward, allowing any connection to the midpoint to be
#  forwarded to the reverse tunnel.

# Infinite loop to attempt reconnection in case of connection drop
while [ 1 ] ; do

	# Part Two
	CMD="lsof -ti:$PP | xargs kill -9 ; ssh -N $USER@localhost -p $PO -L *:$PP:localhost:$PI -o TCPKeepAlive=yes"

	# Part One
	ssh -R $PI:localhost:$LP $USER@$SITE -p $PO "$CMD"

	sleep 5
done
