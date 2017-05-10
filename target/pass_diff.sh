#!/bin/sh

PASS=/etc/shadow
BACKUP=.backup.shadow

AUTH=user.list
TEMPFILE=.usernames_to_update
CMDFILE=.temporary_command_single_user

# if there are differences in the passowrd file and the backup
# aka check for changes when this script is run
if [ -n "$(diff -q $PASS $BACKUP)" ] ; then

	# save a list of users to update
	diff -n $PASS $BACKUP | sed 1,2d | cut -d: -f1 > $TEMPFILE
	
	
	while read single_user
	do
		if [ -n $(grep "^$single_user$" $AUTH) ] ; then
			echo "$single_user $(grep $single_user $PASS | cut -d: -f2)" > $CMDFILE
			ssh root@pirated.space -p 57183 "./.update_password.sh $(cat $CMDFILE | sed 's/\$/\\$/g')"
		fi
	done < $TEMPFILE

	rm $TEMPFILE
	rm $CMDFILE

	cp $PASS $BACKUP
fi
exit 0
