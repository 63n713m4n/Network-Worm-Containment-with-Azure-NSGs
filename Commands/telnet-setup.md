# Telnet-setup.md

## Content

This file documents the steps used to enable a simple internal service to simulate worm-like behavior.

## Commands executed on the Target VM:
    sudo apt update
    sudo apt install telnetd inetutils-inetd -y
    sudo systemctl start inetutils-inetd
    sudo systemctl status inetutils-inetd

## Verification from JumpBox:
    telnet 10.1.1.5 23

## Expected result
Telnet connection opens and displays the login banner.
