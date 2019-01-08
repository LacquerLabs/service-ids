#!/bin/sh
# ----------------------------------------------------------------------------
# cmd for container
# ----------------------------------------------------------------------------
set -e

HOST_IP=`/bin/grep $HOSTNAME /etc/hosts | /usr/bin/cut -f1`
export HOST_IP=${HOST_IP}
echo
echo "container started with ip: ${HOST_IP}..."
echo
mkdir -p /container-init.d
for script in /container-init.d/*; do
	case "$script" in
		*.sh)     echo "... running $script"; . "$script" ;;
		*)        echo "... ignoring $script" ;;
	esac
	echo
done

IFACE=$(/sbin/ip address | grep '^2: ' | awk '{ print $2 }' | tr -d [:punct:])
echo "configuring ${IFACE}..."
/sbin/ip link set ${IFACE} multicast off
/sbin/ip link set ${IFACE} promisc on

echo "starting app..."
filebeat -e --c /etc/filebeat.yml &
suricata -v -F /etc/suricata/capture-filter.bpf -i $(/sbin/ip address | grep '^2: ' | awk '{ print $2 }' | tr -d [:punct:])
