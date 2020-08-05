#!/bin/bash

source /etc/ssh-tunneler/tunneler.conf

PROXY_PORT="%%PROXY_PORT%%"

LOCAL_PORT="%%LOCAL_PORT%%"

#  -vv |  Verbosity level 2
#  -N  |  Do not execute a remote command
#  -R  |  Forward connections *:from anywhere on the remote port to the local port
#  -o  |  Additional SSH Options: 
#      |    TCPKeepAlive detects when the connection drops or the remote host crashes

ssh -vv -N $PROXY_HOST -R *:$PROXY_PORT:localhost:$LOCAL_PORT -o TCPKeepAlive=yes
