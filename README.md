## SSH Tunnel Demo
This will be a crash course tutorial in how to set up a "Reverse Proxy SSH Tunnel" between unix machines.
Used primarily to create an inbound connection route behind a firewall when one would be otherwise impossible.


##### What you will need:
- A command line interface (or TTY) (on your client machine)
- A target machine (The machine that sits behind the firewall)
- An intermediary machine (Something that is always available to connect to)
<br><br>

##### From here they will be referred to as:
- Client
- Target
- Proxy
<br><br>
*Real quick, why? Because Target is behind a firewall that doesn't allow inbound connections. So if we try:*
```
user@client:~$ ssh user@target
```
*We get an error that Target cannot be reached, or similar. The work around is that Client and Target can both see the Proxy, so we use the Proxy as a middleman.*
<br><br>
<br><br>
*Source code can be found in `.tunnel_loop.sh`*
<br><br>
<br><br>

#### Part 1: Variables

```
SITE=""
USER=""
PO=""
PP=""
PL=""
PI=""
```
#### Explanation:
- **SITE** : The IP or web address of the proxy machine.
- **USER** : The user account on the proxy used to set up the connection. (They must have permission to open ports)
- **PO** : Port Open - The SSH listening port on the proxy machine.
- **PP** : Port Proxy - The port that will be used to forward the connection on the client side. For example:
```
user@client:~$ ssh user@proxy -p $PO
user@proxy:~$
...
user@client:~$ ssh user@proxy -p $PP
user@target:~$
```
- **PL** : Port Local - The SSH listening port on the target machine.
- **PI** : Port Intermediary - A port on Proxy that will be used to bridge two connections, more on that later.
<br><br>
<br><br>
