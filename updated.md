## Reverse SSH Tunnel
_AKA a poor man's port forwarding_


#### Make the appropriate changes to the accessible proxy:
- Add a system user that handles listening and opening ports, but can do nothing else.
  Note that anyone who has access to this could open a tunnel pointed at the tunnel, and DOS your proxy with an infinite loop. So we want to keep it locked down to a least priveledged access model.

```
# execute all of the following as root

# add a system user to maintain the ssh tunnel
# /bin/false means you can't get a shell even if you have a valid login. (there are probably still l33t workarounds)
useradd -m -s /bin/false wormhole

# if you want the homedir somewhere else, use "-d directory" in the useradd command
cd /home/wormhole
```
- Add the necessary ssh access resources to get it working
```
mkdir .ssh
# At this point, put your own ssh public key here for testing.
# We'll remove it later when we have summoned the Host service daemon, and add its keys.
# I don't care how it gets here, this just assumes you've magicked it in.
cat id_rsa.pub >> .ssh/authorized_keys

# we will leave the authorized_keys owned by root, readable by the wormhole user
# we don't want anyone else modifying this file, even if they can finagle an illegitimate login
chgrp wormhole .ssh/authorized_keys
chmod 640 .ssh/authorized_keys
```
- Enable port forwarding via the `/etc/ssh/sshd_config` file. 
  (`vim /etc/ssh/sshd_config`, this doesn't work in emacs :)
```
# I'm not going to tell you how to secure your ssh service. But at a minimum,
# You should be using a non-standard port (anything but 22), and disable password authentication.
Port 12345
PasswordAuthentication no

# This part is what's important for our uses
# This is off by default, which is good
#GatewayPorts no
# But we have to enable it, _for only the tunnel_
Match user wormhole
  GatewayPorts yes
```
- That's it. `sshd -t` or `reboot` to reload the configuration.
- To test, run each of these in separate shells on your machine (not the proxy)
```
# set up a listener on any port, for example 45678
nc -l 45678
```
```
# the ports in the reverse tunnel can be the same,
# I'm explicitly making them different for example purposes
ssh -N wormhole@exampleproxy.com -p 12345 -R *:45679:localhost:45678 -o TCPKeepAlive=yes
```
```
nc exampleproxy.com 45679
asdf  # in nc, if the listener shell shows asdf, then it works and you can close all of them
```

# Make changes to the remote host:
- Add a system user to manage opening the outbound connections to the proxy
```
useradd -m -s /bin/false -d /etc/ssh-tunneler/ tunneler
# I chose the /etc directory because reasons. It's maybe not Best Practice:tm:,
# but this is little more than some configuration and startup scripts.
# (and a shell script to add more as needed)
```
- Fetch the relevant files from this repo
```
cd /etc/ssh-tunneler; git clone https://github.com/izcet/ssh_tunnel.git
# I'm using this as a shortcut to `curl`ing, `vim`ing, or otherwise magicking the scripts to this location.
# Disclaimer: DO NOT JUST COPY CODE OFF THE INTERNET ONTO YOUR RUNNING MACHINES, especially not as root.
# This repo is MIT and I'm providing this explanation as-is, mostly for myself to document some configs I made.
# You are responsible for reasoning about the actions you're taking and the code you decide to run.
# (note to self: verify the license is added to the repo)

# Anyway, I only need the systemd template files, creator script, and config.
# Most of those are provided in the repo.
cp -r ssh_tunnel/template ssh_tunnel/new-tunnel.sh .
rm -rf ssh_tunnel
```
- Add your specific configuration to `tunneler.conf`. The scripts are assuming it looks like this:
```
#!/bin/bash

export PROXY_HOST="wormhole@exampleproxy.com -p 12345"
```

FROM THIS POINT TO THE END OF THE DOCUMENT IS INCOMPLETE AND WILL BE UPDATED IN THE NEXT COMMIT
- Make the ssh key for the tunneler system user.
```
```
- Copy the id\_rsa.pub to the proxy's `authorized_keys` for the wormhole user.
  You can delete other keys you had earlier for testing. 
- Last step, connect the host to the proxy



mkdir .ssh


sudo -u tunneler ssh $PROXY_HOST
# fails but it adds to known host as we need

