#/bin/sh

FILE=userlist

if [ -n "$1" ] ; then
	FILE=$1
fi

echo "reading from file $FILE"

while read LINE
do
	USER=$(echo $LINE | cut -d: -f1)
	PASS=$(echo $LINE | cut -d: -f2)
	KEY=""
	NUM=3
	while [ -n "$(echo $LINE | cut -d: -f $NUM)" ] ; do
		TEMP=$(echo $LINE | cut -d: -f$NUM )
		KEY=$(echo "$KEY $TEMP")
		NUM=$((NUM + 1))
	done
	KEY=$(echo $KEY | tr " " "\n")
	echo "$USER , $PASS"
	#echo "$KEY"

	./add_new_user.sh "$USER" "$PASS" "$KEY"

done < $FILE

