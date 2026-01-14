# Network-Worm-Containment-with-Azure-NSGs
## PROJECT OVERVIEW

This repository contains all supporting material for the academic project titled
“Network Worm Containment Using Azure Network Security Groups”.

The project demonstrates how lateral movement inside a cloud network can be restricted using Azure’s built-in network security controls. A controlled Azure environment was created to simulate worm-like behavior between internal virtual machines, followed by containment using a subnet-level Network Security Group rule.

All experiments were conducted in an isolated academic environment. No real malware was used.

## PROJECT OBJECTIVE

The objective of this project is to evaluate the effectiveness of Azure Network Security Groups in preventing lateral movement between virtual machines deployed within the same subnet.

The project focuses on:
	•	Demonstrating unrestricted internal connectivity in a flat cloud network
	•	Simulating worm-like behavior using safe tools and services
	•	Applying subnet-level network segmentation
	•	Verifying containment using connectivity tests and flow logs

# EXPERIMENT ENVIRONMENT

Cloud Platform
Microsoft Azure

Operating System
Ubuntu Server

## Core Components
	•	Virtual Network with a single subnet
	•	JumpBox virtual machine with public access
	•	Target virtual machine with internal-only access
	•	Subnet-level Network Security Group
	•	Azure Network Watcher virtual network flow logs

## Tools Used
	•	Ping
	•	Telnet
	•	Metasploit Framework (auxiliary scanner modules only)

# EXPERIMENT WORKFLOW
	1.	A virtual network and subnet were created to represent a flat internal cloud network.
	2.	Two Ubuntu Server virtual machines were deployed within the same subnet.
	3.	Baseline tests confirmed unrestricted internal communication.
	4.	A Telnet service was enabled on the target system to simulate a weak internal service.
	5.	Metasploit auxiliary scanners were used to identify open services.
	6.	A subnet-level Network Security Group rule was applied to deny all internal traffic.
	7.	Connectivity tests and scans were repeated to confirm containment.
	8.	Virtual network flow logs were used to verify that denied traffic was recorded.

# REPOSITORY CONTENTS
	•	Command references used during testing
	•	Network Security Group rule configuration details
	•	Metasploit modules used for service visibility
	•	Flow log evidence confirming blocked traffic
	•	Supporting notes for report and presentation
	•	Screenshots

# KEY FINDINGS
	•	Flat cloud networks allow unrestricted lateral movement by default
	•	Subnet-level Network Security Groups effectively block internal traffic
	•	Worm-like behavior can be contained without modifying virtual machines
	•	Azure Network Watcher flow logs provide verification of blocked traffic

		
# REPOSITORY STRUCTURE
	•	network-worm-containment-azure-nsg/
		│
		├── README.md
		│
		├── architecture/
		│   └── architecture-diagram.png
		│
		├── Commands/
		│   ├── baseline-tests.md
		│   ├── telnet-setup.md
		│   ├── metasploit-tests.md
		│   └── nsg-configuration.md
		│
		├── logs/
		│   ├── PT1H.json
			├── PT1H.png
		│	└──README.md
		├── screenshots/
		│   ├── before-firewall/
		│   └── after-firewall/
		│   
		│
		└── notes/
		    └── project-notes.md
	

# ETHICAL NOTE

All testing was performed in a private academic environment created solely for this project.
No real malware, exploits, or unauthorized access techniques were used.
