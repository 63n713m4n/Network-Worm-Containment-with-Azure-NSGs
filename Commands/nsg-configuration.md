# Network Security Group Configuration

## Content

This file documents the Network Security Group rule used to block lateral movement.

## Inbound rule configuration:
    	•	Source: VirtualNetwork
	    •	Source port: *
	    •	Destination: VirtualNetwork
    	•	Destination port: *
    	•	Protocol: Any
    	•	Action: Deny
    	•	Priority: 200

The NSG is attached at the subnet level to enforce micro-segmentation.

## Expected result
All internal traffic between virtual machines is blocked.
