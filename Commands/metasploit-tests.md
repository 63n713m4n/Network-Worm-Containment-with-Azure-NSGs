# Metasploit Installation and Testing

## Content

This document describes how Metasploit Framework was installed on the JumpBox virtual machine and how it was used for safe service visibility testing in the project.

## Metasploit Installation on JumpBox

Metasploit was installed only on the JumpBox, which acted as the attacker simulation machine. The Target virtual machines did not have Metasploit installed.

Operating system: Ubuntu Server

## Steps
## Update the system:
    sudo apt update
    sudo apt upgrade -y

## Install Metasploit Framework:
    sudo apt install metasploit-framework -y

## Start and enable PostgreSQL:
    sudo systemctl start postgresql
    sudo systemctl enable postgresql

## Initialize the Metasploit database:
    sudo msfdb init

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


## Purpose of Metasploit Usage
Metasploit was used only to simulate attacker reconnaissance behavior. The goal was to demonstrate how service visibility changes before and after applying a subnet-level Network Security Group rule.

# No real malware, exploitation, or unauthorized activity was performed
