#!/bin/sh
systemd-run -p "User=${1}" -p "PAMName=login" -p "TTYPath=/dev/tty4" --wait setpriv --ambient-caps -wake_alarm /usr/share/gamescope-session-plus/gamescope-session-plus steam
check_tty=`loginctl list-sessions | grep tty2`
if [[ $check_tty != "" ]]; then
	sudo chvt 2 
else
	sudo chvt 1
fi
pkill mangoapp; 
pkill ibus-daemon;
echo "gamescope session exited."
