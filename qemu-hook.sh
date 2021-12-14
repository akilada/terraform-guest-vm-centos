#!/bin/bash
#
# Hook script for QEMU
# 
# adds port forwards via IPtables to your VMs
#
# Erico Mendonca (erico.mendonca@suse.com)
# dec/2018
#
# https://github.com/doccaz/kvm-scripts
#
# Adapted by Branislav Siarsky
# apr/2020
#

log() {
        logger -t addForward "$1"
}

addForward() {
   VM=$1
   HOST_NIC=$2
   HOST_IP=$3
   HOST_PORT=$4
   GUEST_NIC=$5
   GUEST_IP=$6
   GUEST_PORT=$7
   PROTOCOL=$8

   IPTABLES="/usr/sbin/iptables"
   IP="/usr/sbin/ip"
   HOST_IP_MASK="24"
   IPTABLES_ACTION=""
   IPTABLES_TEXT=""
   IP_ACTION=""
   IP_TEXT=""

   if [ "${VM}" == "${VM_NAME}" ]; then
     if [ "${ACTION}" == "stopped" ]; then
       IPTABLES_ACTION="-D"
       IPTABLES_TEXT="Removing forwarding rules for VM ${VM}"
       IP_ACTION="del"
       IP_TEXT="Removing IP ${HOST_IP} from ${HOST_NIC}"
     fi

     if [ "${ACTION}" == "start" ] || [ "${ACTION}" == "reconnect" ]; then
       IPTABLES_ACTION="-I"
       IPTABLES_TEXT="Adding forwarding rules for VM ${VM}: host port ${HOST_PORT} will be redirected to ${GUEST_IP}:${GUEST_PORT} on interface ${GUEST_NIC}"
       IP_ACTION="add"
       IP_TEXT="Adding IP ${HOST_IP} to ${HOST_NIC}"
     fi

     if [ "${IPTABLES_ACTION}" == "" ]; then
       log "Action ${ACTION} on domain $VM not configured, ignoring"
       exit 0
     else 
       log "Action ${ACTION} on domain $VM called"
     fi

     log "${IPTABLES_TEXT}"
     log "running: $IPTABLES ${IPTABLES_ACTION} FORWARD -o ${GUEST_NIC} -d $GUEST_IP -j ACCEPT"
     $IPTABLES ${IPTABLES_ACTION} FORWARD -o ${GUEST_NIC} -d $GUEST_IP -j ACCEPT

     if [[ "${PROTOCOL}" == *"tcp"* ]] || [[ "${PROTOCOL}" == *"TCP"* ]]; then
      log "running: $IPTABLES -t nat ${IPTABLES_ACTION} PREROUTING -d $HOST_IP -p tcp --dport $HOST_PORT -j DNAT --to $GUEST_IP:$GUEST_PORT"
      $IPTABLES -t nat ${IPTABLES_ACTION} PREROUTING -d $HOST_IP -p tcp --dport $HOST_PORT -j DNAT --to $GUEST_IP:$GUEST_PORT
     fi

     if [[ "${PROTOCOL}" == *"udp"* ]] || [[ "${PROTOCOL}" == *"UDP"* ]]; then
      $IPTABLES -t nat ${IPTABLES_ACTION} PREROUTING -d $HOST_IP -p udp --dport $HOST_PORT -j DNAT --to $GUEST_IP:$GUEST_PORT
     fi

     log "${IP_TEXT}"
     log "running: $IP address ${IP_ACTION} ${HOST_IP}/${HOST_IP_MASK} dev ${HOST_NIC} "
     ### IMPORTANT: uncomment the following line ONLY if you need to assign/remove a different IP to an existing host interface.
     ### If you specify the current fixed IP for the interface, IT WILL BE REMOVED when the VM is stopped (and you'll lose conectivity).
     # $IP address ${IP_ACTION} ${HOST_IP}/${HOST_IP_MASK} dev ${HOST_NIC} 
   fi
}

## main program
VM_NAME=${1}
ACTION=${2}

### declare your port forwards here
### format: addForward <VM> <source nic> <source address> <source port> <destination nic> <destination address> <destination port> <protocol>
### Examples:
# Port 80 forward:   addForward debian10-vm2 enp3s0f0 192.168.1.17 80 virbr0 192.168.122.2 80 tcp
# All ports forward: addForward debian10-vm2 enp3s0f0 192.168.1.17 1:65535 virbr0 192.168.122.2 1-65535 tcp,udp
#
# addForward debian10-vm1 enp3s0f0 192.168.1.16 1:65535 virbr0 192.168.122.16 1-65535 tcp
# addForward debian10-vm2 enp3s0f0 192.168.1.17 1:65535 virbr0 192.168.122.17 1-65535 tcp
# addForward debian10-vm3 enp3s0f0 192.168.1.18 1:65535 virbr0 192.168.122.18 1-65535 tcp
# addForward debian10-vm3 enp3s0f0 192.168.1.18 1:65535 virbr0 192.168.122.18 1-65535 tcp
# addForward RMT eth0 10.1.2.3 80 virbr-suse 192.168.110.100 80 tcp
# addForward RMT eth0 10.1.2.3 443 virbr-suse 192.168.110.100 443 tcp
addForward centos-2 enp0s31f6 192.168.1.184 22222 virbr0 192.168.122.210 22 tcp
