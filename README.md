## SSH Tunnel Demo
This will be a crash course tutorial in how to set up a "jump tunnel" between users on unix machines.
I'll also be showing how to set this up behind a protected firewall to create an inbound connection when one would be
otherwise impossible.


##### What you will need:
- A command line interface (or TTY) (on your client machine)
- A target machine (The machine that sits behind the firewall)
- An intermediary machine (Something that is always available to connect to)
<br><br>

##### From here they will be referred to as:
- Client
- Target
- Jumper
<br><br>

## First, set up your users
The most common command for linux systems is `adduser`, sometimes with or without modifiers.

```
root@target:~$ adduser example
```
```
root@jumper:~$ adduser launchpad
```
You will want to make sure that they have adequate permissions and an appropriate shell at first, though this can be
modified later.
<br><br>
<br><br>

## Second, set up key pairs for authentication
These are more secure than passwords for authentication, and allow for instantaneous connection.

```
example@target:~$ ssh-keygen -t rsa
```
```
jumper@launchpad:~$ ssh-keygen -t rsa
```
If you don't already know how to handle keys, I highly recommend looking it up. This crash course will be a
good introduction but nothing beats research and regular usage.
<br><br>
<br><br>

## Third, copy keys from Target to Jumper and make the outbound connection
An easy and secure way to copy RSA keys from one unix machine to another is with `ssh-copy-id`.
- This isn't always available. 
- In those cases use:
- `cat ~/.ssh/id_rsa.pub | ssh user@target.machine 'echo >> .ssh/authorized_keys'`
<br><br>
```
example@target:~$ ssh-copy-id jumper@launchpad
...
[anyuser]@target:~$ ssh -R [port1]:localhost:[port2] [anyuser]@launchpad
```
#### Explanation:
- Any user can be used to initialize the tunnel, as long as they are allowed to make ssh connections as a client. Hint:
you can even have it run as a script in the background, and/or launch at startup.
- Ports haven't really been covered yet, but it's good practice to change your `/etc/ssh/sshd_config` file to listen on
a different port. In addition, with this tunnel, the Jumper machine will need to know when a connection is inbound
towards the Jumper, or inbound towards the Target.
- port1 : the port that Jumper listens to in order to forward to Target
- localhost : Target wants connections to be forwarded to itself. 
- port2 : the port that Target listens to for inbound ssh connections (`/etc/ssh/sshd_config`)
- Any user can be used to recieve the connection, but they must be a user that can be signed into (aka have a shell that is
not `/bin/false` or equivalent)

<br><br><br><br><br><br>
TODO: Demonstrate the automation of creating a user via shell script
TODO: Setup key generation for other users via shell script
TODO: Look up port forwarding in `GatewayPorts` in `/etc/ssh/sshd_config`
Todo: make sense of the potential for `ssh -R *:[port1]:localhost:[port2] ...`


