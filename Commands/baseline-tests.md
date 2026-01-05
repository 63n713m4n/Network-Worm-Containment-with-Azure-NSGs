Ping test from JumpBox to Target VM:

ping <target_private_ip>

SSH connectivity test:

ssh <username>@<target_private_ip>

Port scan using nmap:

sudo apt install nmap -y
nmap <target_private_ip>

## Expected result
All commands succeed, confirming unrestricted internal communication.

