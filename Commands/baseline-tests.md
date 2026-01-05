# Baseline Connectivity Tests

## Ping test from JumpBox to Target VM:
    ping 10.1.1.5

## SSH connectivity test:
    ssh Target1@10.1.1.5

## Port scan using nmap:
    sudo apt install nmap -y 
    nmap 10.1.1.5

# Expected result
All commands succeed, confirming unrestricted internal communication.

