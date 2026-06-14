#!/bin/bash
# mac-sleep-schedule.sh
# Schedules daily suspend (sleep) and wake (local time).
# Uses pmset repeat which honors the system timezone.
# Must be run with sudo (except for status).
#
# Usage:
#   sudo ./sleep-schedule.sh enable  SLEEP_HH:MM WAKE_HH:MM
#   sudo ./sleep-schedule.sh disable
#   ./sleep-schedule.sh status
#
# Examples:
#   sudo ./sleep-schedule.sh enable 00:30 07:30
#   sudo ./sleep-schedule.sh enable 23:00 06:00

set -euo pipefail

DAYS="MTWRFSU"          # every day of the week

usage() {
    cat >&2 <<EOF
Usage:
  sudo $0 enable  SLEEP_HH:MM WAKE_HH:MM
  sudo $0 disable
       $0 status

Examples:
  sudo $0 enable 00:30 07:30
  sudo $0 enable 23:00 06:00
EOF
    exit 1
}

validate_time() {
    local label="$1" value="$2"
    if [[ ! "$value" =~ ^([01][0-9]|2[0-3]):[0-5][0-9]$ ]]; then
        echo "ERROR: Invalid $label time '$value'. Expected HH:MM (00:00-23:59)." >&2
        exit 1
    fi
}

require_root() {
    if [[ $EUID -ne 0 ]]; then
        echo "ERROR: This command must be run as root (use sudo)." >&2
        exit 1
    fi
}

do_enable() {
    require_root
    [[ $# -ne 2 ]] && usage

    local sleep_time="$1" wake_time="$2"
    validate_time "sleep" "$sleep_time"
    validate_time "wake"  "$wake_time"

    echo "=== Enabling Sleep/Wake Schedule ==="
    echo ""
    echo "  Sleep : every day at $sleep_time"
    echo "  Wake  : every day at $wake_time"
    echo "  TZ    : $(readlink /etc/localtime 2>/dev/null | sed 's|.*/zoneinfo/||' || echo "unknown")"
    echo ""

    pmset repeat sleep "$DAYS" "${sleep_time}:00" wakeorpoweron "$DAYS" "${wake_time}:00"

    echo "Schedule enabled. Verify with: $0 status"
}

do_disable() {
    require_root
    echo "=== Disabling Sleep/Wake Schedule ==="
    echo ""

    pmset repeat cancel

    echo "All repeating power events removed."
    echo "Verify with: $0 status"
}

do_status() {
    echo "=== Current Power Schedule ==="
    echo ""
    pmset -g sched
}

# ---- main ----
[[ $# -lt 1 ]] && usage

cmd="$1"; shift

case "$cmd" in
    enable)  do_enable "$@"  ;;
    disable) do_disable      ;;
    status)  do_status       ;;
    *)       usage           ;;
esac
