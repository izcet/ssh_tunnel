#!/bin/sh

USERNAME=$1
PASSWORD=$2
PUB_KEY=$3

GROUP=crew

if [ "$#" -lt 2 ] ; then
	echo "What is the name?"
	read USERNAME
	echo "What is the password?"
	read PASSWORD
	echo "What is the public key?"
	read PUB_KEY
fi

if [ -n "$(grep -e ^$USERNAME: /etc/passwd)" ] ; then
	echo "User $USERNAME already exists"
	exit 1
fi

useradd -m -g $GROUP $USERNAME
echo "$USERNAME:$PASSWORD" | chpasswd


mkdir -p /home/$USERNAME/.ssh/
echo "$PUB_KEY" >> /home/$USERNAME/.ssh/authorized_keys
chown -R $USERNAME /home/$USERNAME/.ssh
chmod 664 /home/$USERNAME/.ssh/authorized_keys
chmod 700 /home/$USERNAME/.ssh

# expire the password so they are forced to change on first login
passwd -e -q $USERNAME

exit 0
