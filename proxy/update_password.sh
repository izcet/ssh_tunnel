#!/bin/sh

NAME=$1
LINE=$2

ERR=log/passord_update

PASS=/etc/shadow

input_error () {
	echo "Input error: $(date): \"$NAME\": \"$LINE\"" >> $ERR
	exit 1
}

lookup_error () {
	echo "Lookup error: $(date): \"$NAME\": \"$LINE\"" >> $ERR
	exit 1
}

if [ -z $NAME ] ; then
	input_error
fi

if [ -z $LINE ] ; then
	input_error
fi

if [ -z $(cat $PASS | grep ^$NAME) ] ; then
	lookup_error
fi

cat $PASS | grep -v ^$NAME | cat > .tempupdatepass
mv .tempupdatepass $PASS
echo $LINE >> $PASS 

exit 0
