#!/bin/bash

#############################################################################
#                                                                           #
# Last Update:  2022-11-12                                                  #
# Version:      1.00                                                        #
#                                                                           #
# Changes:      Initial Version (1.00)                                      #
#                                                                           #
#                                                                           #
#############################################################################

if [[ -z $1 ]]; then
	-e "\e[1;32m - install_prerequisites()\e[0m";
	echo -e "\e[1;31mNo hostname supplied, use WoS.sh RemoteHost RemoteInterface RemotePort RemoteUser RemoteKey"
	echo -e
	echo -e "\e[1;32mExample: ./WoS.sh server1 eth0 10022 root ~/.ssh/id_ed25519"
	echo -e "If everything else is in place, try ./WoS.sh server1 eth0\e[0m"
	exit 1
else
	HOST=$1
fi

if [[ -z $2 ]]; then
	echo "No interface supplied, using \'any\'"
	IFACE="any"
else
	IFACE=$2
fi

if [[ -z $3 ]]; then
	echo "No port supplied, using default SSH port 22"
	PORT="22"
else
	PORT=$3
fi

if [[ -z $4 ]]; then
        echo "No remote user supplied, using root"
        USER="root"
else
        USER=$4
fi

if [[ -z $5 ]]; then
	echo "No SSH key supplied running without"
	echo "TCPDUMPing from host: $HOST, Interface: $IFACE, Port: $PORT"
	ssh -p$PORT $USER@$HOST tcpdump -i $IFACE -U -n -s0 -w - "not port $PORT" | wireshark -k -i -
else
	KEYPATH=$5
	echo "using specified key"
	ssh -p$PORT -i $KEYPATH $USER@$HOST tcpdump -i $IFACE -U -n -s0 -w - "not port $PORT" | wireshark -k -i -
fi
