# Metasploit Auxiliary Scans

## Content

This file documents the Metasploit modules used for safe service visibility testing.

## Start Metasploit:
    msfconsole

## TCP port scan:
    use auxiliary/scanner/portscan/tcp
    set RHOSTS 10.1.1.5
    set PORTS 1-1024
    run 

## Telnet version scan: 
    use auxiliary/scanner/telnet/telnet_version
    set RHOSTS 10.1.1.5
    run

## Expected result before NSG
Open ports and Telnet service are detected.

## Expected result after NSG
Scans fail or time out.
