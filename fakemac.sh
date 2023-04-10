#!/bin/bash


echo " ____  __    _  _  ____  __  __    __    ___ "
echo "( ___)/__\  ( )/ )( ___)(  \/  )  /__\  / __)"
echo " )__)/(__)\  )  (  )__)  )    (  /(__)\( (__ "
echo "(__)(__)(__)(_)\_)(____)(_/\/\_)(__)(__)\___)"
# help msg 
if [[ "$1" == "" ]]; then
  echo "usage   : bash fakemac.sh <interface name>"
  echo "example : bash fakemac.sh wlan0"
  exit 0
fi
# run as root condition 
if [ "$(id -u)" -ne 0 ]; then echo "Please run as root." >&2; exit 1; fi
# check dependencies
if [[ $(which macchanger 2>/dev/null) && $(which ifconfig 2>/dev/null) ]];then
  echo "Author : GHOST"
  echo "GitHub : mdk4if"
else
  echo "[!] requires macchanger and net-tools to work. Aborting"
  exit 0
fi

# sanitizing and saving mac address to a file 
macchanger -l | awk '{print $3}' | sed '/^[[:space:]]*$/d' | grep -i -v "vendor" | grep -i -v "-" > .maclist.txt
# making mac address
macHead=$(shuf -n 1 .maclist.txt)
macTail=$(printf '%02x:%02x:%02x' $[RANDOM%256] $[RANDOM%256] $[RANDOM%256])


# changing mac address
sudo ifconfig "$1" down
sudo macchanger -m "$macHead:$macTail" "$1"
sudo ifconfig "$1" up
