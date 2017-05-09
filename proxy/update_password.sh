#!/bin/sh

NAME=$1
LINE=$2

ERR=log/passord_update

PASS=/etc/shadow
AUTH=user.list

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

if [ -z $(cat $PASS | grep ^$NAME: ) ] ; then
	lookup_error
fi

if [ -z $(cat $AUTH | grep ^$NAME$ ) ] ; then
	lookup_error
fi

REMAINDER=$(cat $PASS | grep ^$NAME: | cut -d: -f3- )

cat $PASS | grep -v ^$NAME | cat > .tempupdatepass
mv .tempupdatepass $PASS
echo "$NAME:$LINE:$REMAINDER" >> $PASS 

exit 0
