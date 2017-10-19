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
*Source code can be found in [.tunnel_loop.sh](https://github.com/izcet/ssh_tunnel/blob/master/.tunnel_loop.sh).*
<br><br>
<br><br>


## Part -1: Keys
These are more secure than passwords for authentication, and allow for instantaneous connection.
```
user@machine:~$ ssh-keygen -t rsa -b 4096
...
user@client:~$ ssh-copy-id user@target
```
#### Explanation:
- **-t** key type: RSA. Because I said so.
- **-b** number of bits: The longer the better. 2048 (the length) should be secure until 2030 (the year)
- **ssh-copy-id** copies the RSA key generated on the local machine to the machine at address (IP/Domain and Port required for SSH). This command is not available on all machines. In those cases use:
- `cat ~/.ssh/id_rsa.pub | ssh [user]@[target.machine] 'echo >> .ssh/authorized_keys'`

<br>
If you don't already know how to handle keys, I highly recommend looking it up. This will get you off the ground but nothing beats research and regular usage.
<br><br>


## Part 0: Variables
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

## Part 1: Reverse Tunnel
```
ssh -R $PI:localhost:$PL $USER@$SITE -p $PO "$CMD"
```
#### Explanation:
- `ssh -R` : Running `ssh` with the `-R` flag initializes the reverse tunnel.
- `$PI:localhost:$PL` : This tells the system we want the remote port `$PI` to be forwarded to port `$PL` on `localhost`.
- `$USER@$SITE -p $PO` : This is the standard ssh connection information. We're connecting as `$USER` at address `$SITE` on port `$PO` (assuming it's not the standard port `22`).
- `"$CMD"` : Run this command when the connection is established. (Part 2)
<br><br>

If you don't want your connection to be public, you can stop here. Anyone with access to the Proxy can run
```
ssh user@localhost -p $PI
``` 
and their connection will be forwarded to the target machine. If you stop here, `$CMD` will have to be a `while [ 1 ]` or some other method of keeping the connection alive.
<br><br>
<br><br>

## Part 2: Port Forward
```
CMD="lsof -ti:$PP | xargs kill -9 ; ssh -N $USER@localhost -p $PO -L *:$PP:localhost:$PI -o TCPKeepAlive=yes"
```
#### Explanation:
- `lsof -ti:$PP | xargs kill -9 ;` : First, kill off any processes that might be reserving the proxy port you want to use. Not usually an issue, but there is an edge case if the connection gets interrupted that the Proxy will still reserve the port for a tunnel that doesn't exist, preventing a new process from binding to it. This ensures that the port is always available.
- `ssh $USER@localhost -p $PO` : Connect the proxy to itself to open a tunnel.
- `-N` : Don't execute a command, just forward a port.
- `-L *:$PP:localhost:$PI` : `-L` Forward connections from `*` (anywhere) on port `$PP` (the port we want to use to forward) to `localhost` at port `$PI` (The intermediary port that Target is already listening on). *See diagram below.*
- `-o TCPKeepAlive=yes"` : Keep the connection alive even though no commands are being run.
<br><br>

Some Examples:
```
SITE="some_website.com"
USER="root"
PO="22"
PP="55555"
PL="22"
PI="55554"
```
```
user@client:~$ ssh alice@some_website.com
(client -> proxy:22)
alice@proxy:~$
```
```
user@client:~$ ssh bob@some_website.com -p 55555
(client -> proxy:55555 -> proxy:55554 -> target:22)
bob@target:~$
```
<br><br>
<br><br>

## Part 3: Automation
```
while [ 1 ] ; do

	# Part Two
	# Part One
	
	sleep 5
done
```
#### Explanation
- `while [ 1 ] ; do ... done` : An infinite loop, because if the connection breaks (due to power or internet loss), it isn't restarted. Putting it inside an infinite loop ensures the Target machine will attempt to re-establish the connection with the Proxy.
- `sleep 5` : Wait a bit after each attempted connection.
<br><br>

Another tip is to run this script at startup, either `rc.local` or `init.d`, or other system-specific file.
<br><br>
*Source code for automation can be found in [setup_tunnel.sh](https://github.com/izcet/ssh_tunnel/blob/master/setup_tunnel.sh).*
