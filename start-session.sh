#!/bin/sh
if [[ "$2" == "offline" ]]; then
nft -f - <<EOF
define RESERVED_IP = {
	10.0.0.0/8,
	100.64.0.0/10,
	127.0.0.0/8,
	169.254.0.0/16,
	172.16.0.0/12,
	192.0.0.0/24,
	192.168.0.0/16,
	224.0.0.0/4,
	240.0.0.0/4,
	255.255.255.255/32,
}

table inet gs_steam  {
	chain out {
		type filter hook output priority filter; policy drop;
		ip daddr \$RESERVED_IP accept
		reject
	}
}
EOF
fi
sudo chvt 4
# systemd-run -p "User=${1}" -p "PAMName=login" -p "TTYPath=/dev/tty4" --wait setpriv --ambient-caps -wake_alarm /usr/share/gamescope-session-plus/gamescope-session-plus steam
systemd-run -p "User=${1}" -p "UtmpIdentifier=tty4" -p "UtmpMode=user" -p "PAMName=login" -p "TTYPath=/dev/tty4" -p "TTYReset=yes" -p "TTYVHangup=yes" -p "TTYVTDisallocate=yes"  -p "NoNewPrivileges=true" -p "AmbientCapabilities=" -p "CapabilityBoundingSet=~CAP_WAKE_ALARM" --wait /usr/share/gamescope-session-plus/gamescope-session-plus steam
check_tty=`loginctl list-sessions | grep tty2`
if [[ "$check_tty" != "" ]]; then
	sudo chvt 2 
else
	sudo chvt 1
fi
pkill mangoapp; 
pkill ibus-daemon;
nft delete table inet gs_steam
echo "gamescope session exited."
