#!/bin/bash
# mac-remote-access-default.sh
# Reverts all changes made by mac-remote-access-tune.sh back to macOS defaults.
# Must be run with sudo.

set -euo pipefail

if [[ $EUID -ne 0 ]]; then
    echo "ERROR: This script must be run as root (use sudo)." >&2
    exit 1
fi

echo "=== Resetting Remote Access to Defaults ==="

# ---------------------------------------------------------------------------
# 1. Power Management -- restore original values
# ---------------------------------------------------------------------------
echo ""
echo "[1/5] Restoring power management defaults..."

pmset -a sleep 1               # Original: 1 minute
pmset -a displaysleep 10       # Original: 10 min
pmset -a disksleep 10          # Original: 10 min
pmset -a standby 0             # Original: 0
pmset -a hibernatemode 3       # Original: macOS default (3 = safe sleep)
pmset -a networkoversleep 0    # Original: disabled
pmset -a powernap 1            # Original: enabled
pmset -a tcpkeepalive 1        # Original: enabled
pmset -a womp 1                # Original: enabled
pmset -a autorestart 0         # Original: disabled
pmset -a ttyskeepawake 1       # Original: enabled

echo "  Done. Power settings restored."

# ---------------------------------------------------------------------------
# 2. SSH Server -- remove keepalive config
# ---------------------------------------------------------------------------
echo ""
echo "[2/5] Removing SSH server keepalive config..."

SSHD_CONF="/etc/ssh/sshd_config.d/200-keepalive.conf"
if [[ -f "$SSHD_CONF" ]]; then
    rm -f "$SSHD_CONF"
    echo "  Removed $SSHD_CONF"
else
    echo "  $SSHD_CONF not found -- nothing to remove."
fi

# Restart sshd to pick up removal
if launchctl kickstart -k system/com.openssh.sshd 2>/dev/null; then
    echo "  sshd restarted."
else
    echo "  WARNING: Could not restart sshd via launchctl. Changes apply on next restart."
fi

# ---------------------------------------------------------------------------
# 3. TCP Keepalive -- restore kernel defaults
# ---------------------------------------------------------------------------
echo ""
echo "[3/5] Restoring TCP keepalive kernel defaults..."

sysctl -w net.inet.tcp.keepidle=7200000      # Default: 2 hours
sysctl -w net.inet.tcp.keepintvl=75000       # Default: 75 seconds
sysctl -w net.inet.tcp.keepcnt=8             # Default: 8
sysctl -w net.inet.tcp.always_keepalive=0    # Default: disabled

# Remove our entries from /etc/sysctl.conf
SYSCTL_CONF="/etc/sysctl.conf"
MARKER="# mac-remote-access-tune"

if [[ -f "$SYSCTL_CONF" ]] && grep -q "$MARKER" "$SYSCTL_CONF"; then
    # Remove the marker line and the 4 setting lines that follow it
    # Also remove the blank line before the marker if present
    sed -i '' "/$MARKER/,+4d" "$SYSCTL_CONF"
    # Clean up any trailing blank lines left behind
    sed -i '' -e :a -e '/^\n*$/{$d;N;ba' -e '}' "$SYSCTL_CONF" 2>/dev/null || true
    echo "  Removed TCP keepalive entries from $SYSCTL_CONF"
else
    echo "  No custom entries found in $SYSCTL_CONF -- nothing to remove."
fi

# Remove sysctl.conf entirely if it's now empty
if [[ -f "$SYSCTL_CONF" ]] && [[ ! -s "$SYSCTL_CONF" ]]; then
    rm -f "$SYSCTL_CONF"
    echo "  Removed empty $SYSCTL_CONF"
fi

# ---------------------------------------------------------------------------
# 4. VNC / Screen Sharing -- remove custom prefs
# ---------------------------------------------------------------------------
echo ""
echo "[4/5] Resetting Screen Sharing (VNC) preferences..."

defaults delete /Library/Preferences/com.apple.RemoteManagement RestartOnCrash 2>/dev/null && \
    echo "  Removed RestartOnCrash preference." || \
    echo "  RestartOnCrash was not set -- nothing to remove."

# ---------------------------------------------------------------------------
# 5. Wi-Fi -- restore default behavior
# ---------------------------------------------------------------------------
echo ""
echo "[5/5] Restoring Wi-Fi defaults..."

AIRPORT="/System/Library/PrivateFrameworks/Apple80211.framework/Resources/airport"
if [[ -x "$AIRPORT" ]]; then
    "$AIRPORT" prefs DisconnectOnLogout=YES 2>/dev/null && \
        echo "  Restored Wi-Fi DisconnectOnLogout=YES." || \
        echo "  WARNING: Could not reset airport prefs."
else
    echo "  airport utility not found -- skipping Wi-Fi prefs."
fi

# ---------------------------------------------------------------------------
echo ""
echo "=== All settings reverted to defaults. ==="
echo ""
echo "Original values restored:"
echo "  - System sleep: 1 min | Display sleep: 10 min | Disk sleep: 10 min"
echo "  - Standby: 0 | Hibernate: safe sleep (mode 3)"
echo "  - Power Nap: enabled | Auto-restart: disabled"
echo "  - SSH server: no custom keepalive (OS defaults)"
echo "  - TCP stack: keepidle 7200s, always_keepalive=0"
echo "  - VNC: default behavior (no RestartOnCrash)"
echo "  - Wi-Fi: DisconnectOnLogout=YES"
