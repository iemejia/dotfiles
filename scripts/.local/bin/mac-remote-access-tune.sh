#!/bin/bash
# mac-remote-access-tune.sh
# Hardens SSH and VNC (Screen Sharing) for reliable remote access on macOS.
# Must be run with sudo.

set -euo pipefail

if [[ $EUID -ne 0 ]]; then
    echo "ERROR: This script must be run as root (use sudo)." >&2
    exit 1
fi

echo "=== Stabilizing Remote Access ==="

# ---------------------------------------------------------------------------
# 1. Power Management
# ---------------------------------------------------------------------------
echo ""
echo "[1/5] Configuring power management (sleep after 60 min idle)..."

pmset -a sleep 60              # Sleep after 60 min of inactivity
pmset -a displaysleep 0        # Never sleep display (avoids VNC black screen)
pmset -a disksleep 0           # Never sleep disk
pmset -a standby 0             # Disable deep sleep / standby
pmset -a hibernatemode 0       # Disable hibernation
pmset -a networkoversleep 0    # Irrelevant when sleep is disabled
pmset -a powernap 0            # Disable Power Nap (no wake/sleep cycles needed)
pmset -a tcpkeepalive 1        # Maintain TCP connections
pmset -a womp 1                # Wake on Magic Packet / network access
pmset -a autorestart 1         # Auto-restart after power failure
pmset -a ttyskeepawake 1       # TTY sessions prevent idle sleep (needed for SSH)

echo "  Done. Power settings applied."

# ---------------------------------------------------------------------------
# 2. SSH Server Keepalive Configuration
# ---------------------------------------------------------------------------
echo ""
echo "[2/5] Configuring SSH server keepalives..."

SSHD_CONF="/etc/ssh/sshd_config.d/200-keepalive.conf"
cat > "$SSHD_CONF" <<'EOF'
# Stabilize remote SSH connections -- added by mac-remote-access-tune.sh
# Send keepalive probe every 60s; drop after 3 missed probes (180s timeout)
ClientAliveInterval 60
ClientAliveCountMax 3
TCPKeepAlive yes
MaxSessions 20
EOF

chmod 644 "$SSHD_CONF"
echo "  Created $SSHD_CONF"

# Restart sshd to pick up new config
if launchctl kickstart -k system/com.openssh.sshd 2>/dev/null; then
    echo "  sshd restarted."
else
    echo "  WARNING: Could not restart sshd via launchctl. Changes apply on next restart."
fi

# ---------------------------------------------------------------------------
# 3. TCP Keepalive Kernel Tuning
# ---------------------------------------------------------------------------
echo ""
echo "[3/5] Tuning TCP keepalive kernel parameters..."

sysctl -w net.inet.tcp.keepidle=60000        # First probe after 60s idle (was 7200s)
sysctl -w net.inet.tcp.keepintvl=10000       # Retry every 10s (was 75s)
sysctl -w net.inet.tcp.keepcnt=8             # 8 retries before declaring dead
sysctl -w net.inet.tcp.always_keepalive=1    # Enable keepalive on all sockets

# Persist across reboots via /etc/sysctl.conf
SYSCTL_CONF="/etc/sysctl.conf"
MARKER="# mac-remote-access-tune"

if [[ -f "$SYSCTL_CONF" ]] && grep -q "$MARKER" "$SYSCTL_CONF"; then
    echo "  /etc/sysctl.conf already contains our settings -- skipping."
else
    cat >> "$SYSCTL_CONF" <<EOF

$MARKER
net.inet.tcp.keepidle=60000
net.inet.tcp.keepintvl=10000
net.inet.tcp.keepcnt=8
net.inet.tcp.always_keepalive=1
EOF
    echo "  Appended TCP keepalive settings to $SYSCTL_CONF"
fi

# ---------------------------------------------------------------------------
# 4. VNC / Screen Sharing Hardening
# ---------------------------------------------------------------------------
echo ""
echo "[4/5] Hardening Screen Sharing (VNC)..."

defaults write /Library/Preferences/com.apple.RemoteManagement RestartOnCrash -bool true
echo "  Enabled RestartOnCrash for Remote Management."

# ---------------------------------------------------------------------------
# 5. Wi-Fi Stability
# ---------------------------------------------------------------------------
echo ""
echo "[5/5] Configuring Wi-Fi stability..."

AIRPORT="/System/Library/PrivateFrameworks/Apple80211.framework/Resources/airport"
if [[ -x "$AIRPORT" ]]; then
    "$AIRPORT" prefs DisconnectOnLogout=NO 2>/dev/null && \
        echo "  Disabled Wi-Fi DisconnectOnLogout." || \
        echo "  WARNING: Could not set airport prefs (may need SIP disabled)."
else
    echo "  airport utility not found -- skipping Wi-Fi prefs."
fi

# ---------------------------------------------------------------------------
echo ""
echo "=== All changes applied. ==="
echo ""
echo "Summary:"
echo "  - System sleep: 60 min idle | Display/disk sleep: DISABLED"
echo "  - Standby/hibernate: DISABLED"
echo "  - Auto-restart on power failure: ENABLED"
echo "  - TTY keepawake: ENABLED (SSH sessions prevent idle sleep)"
echo "  - SSH server: keepalive every 60s, timeout after 180s"
echo "  - TCP stack: keepidle 60s, probe every 10s, always_keepalive=1"
echo "  - VNC: auto-restart on crash"
echo "  - Wi-Fi: disconnect-on-logout disabled"
echo ""
echo "To undo all changes, run: sudo ./mac-remote-access-default.sh"
