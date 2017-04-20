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
