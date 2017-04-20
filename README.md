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

### First, set up your users
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
TODO: Demonstrate the automation of creating a user via shell script
<br><br>

### Second, set up key pairs for authentication
These are more secure than passwords for authentication, and allow for instantaneous connection.

```
example@target:~$ ssh-keygen -t rsa
```
```
jumper@launchpad:~$ ssh-keygen -t rsa
```
TODO: Setup key generation for other users via shell script

### Third, copy keys and make the outbound connection
An easy and secure way to copy RSA keys from one unix machine to another is with `ssh-copy-id`, though this isn't always
available. In those cases use `cat ~/.ssh/id_rsa.pub | ssh user@target.machine 'echo >> .ssh/authorized_keys'`.


