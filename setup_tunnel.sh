#!/bin/sh

STARTUP="/etc/rc.local"
SCRIPT_PATH="$(pwd)"
TUNNEL=".tunnel_loop.sh"

if [ ! -f $STARTUP ] ; then
	echo "Startup file \"$STARTUP\" does not exist, creating..."
	touch $STARTUP
fi
chmod +x $STARTUP

echo "Adding tunnel script to launch at startup."
echo "Assuming that the tunnel script \"$TUNNEL\" is located at \"$SCRIPT_PATH\""
echo "If the above is not correct, please update \"$STARTUP\""
echo "sh $SCRIPT_PATH/$TUNNEL & \nexit 0" >> $STARTUP

echo "\n Running first-time setup."

echo "\nWhat is the domain ip or name? (SITE)"
read IP

echo "\nWhat is the midpoint user account? (USER)"
read MID_USER

echo "\nWhat is the active sshd port on $IP? (PO)"
read SSHD

echo "\nWhat is the port you want forwarded to this machine? (PP)"
read FORWARD_PORT

echo "\nWhat is the active sshd port on this machine? (LP)"
read LOCAL_PORT

echo "\nWhat port would you like to use as an intermediary? (PI)"
read JUMP_PORT

sed -i '.bak' -e "s/^SITE=\"\"$/SITE=\"$IP\"/" $TUNNEL
sed -i '.bak' -e "s/^USER=\"\"$/USER=\"$MID_USER\"/" $TUNNEL
sed -i '.bak' -e "s/^PO=\"\"$/PO=\"$SSHD\"/" $TUNNEL
sed -i '.bak' -e "s/^PP=\"\"$/PP=\"$FORWARD_PORT\"/" $TUNNEL
sed -i '.bak' -e "s/^LP=\"\"$/LP=\"$LOCAL_PORT\"/" $TUNNEL
sed -i '.bak' -e "s/^PI=\"\"$/PI=\"$JUMP_PORT\"/" $TUNNEL

echo "\nRunning a test connection, Ctrl-C to exit when satisfied."
sh $TUNNEL

