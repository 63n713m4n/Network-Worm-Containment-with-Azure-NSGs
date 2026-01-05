# FLOW LOG EVIDENCE
This directory contains Azure Virtual Network flow log data generated during the experiment.

The file PT1H.json was produced by Azure Network Watcher after applying a subnet-level Network Security Group deny rule. The log records inbound traffic attempts that were blocked before reaching the target virtual machine.

## Key observations from the log:
	  •	Traffic entries are associated with the Network Security Group project_NSG
	  •	The rule DefaultRule_DenyAllInBound is applied
	  •	Flow tuples are marked with a deny action
  	•	No packets or bytes were delivered to the target system

# These logs confirm that internal lateral movement attempts were successfully blocked at the network layer.
