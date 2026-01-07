# ARCHITECTURE OVERVIEW

This directory contains the architecture diagram used in the project
“Network Worm Containment Using Azure Network Security Groups”.

The diagram illustrates the cloud environment created in Microsoft Azure and highlights how lateral movement is contained using a subnet-level Network Security Group.

## ARCHITECTURE DESCRIPTION

    The architecture consists of a single Azure Virtual Network with one subnet. Two Ubuntu Server virtual machines are deployed within the same subnet to represent a flat internal cloud network.

    The JumpBox virtual machine has a public IP address and is used to simulate attacker behavior. It is the only system accessible from the internet and is used to perform internal connectivity tests and service scans.

    The Target virtual machine does not have a public IP address and is accessible only from within the virtual network. A Telnet service is enabled on this system to represent a weak internal service that could be exploited by worm-like malware.

    A Network Security Group is attached at the subnet level. The security group contains a deny rule that blocks all internal traffic originating from and destined to the virtual network. This rule prevents lateral movement between virtual machines inside the subnet.


## TRAFFIC FLOW

    Before the Network Security Group rule is applied, internal traffic between the JumpBox and the Target virtual machine is allowed.

    After the rule is applied, all internal traffic is blocked. Connectivity tests and service scans fail, demonstrating effective containment of lateral movement.


## FILES

architecture-diagram.png
A visual representation of the Azure environment, including the virtual network, subnet, virtual machines, and the subnet-level Network Security Group.

## PURPOSE

The architecture diagram is used in the project report and presentation to provide a clear overview of the experimental setup. It supports the explanation of the methodology and helps illustrate how network-level controls enforce segmentation in cloud environments.
