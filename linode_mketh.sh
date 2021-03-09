 #!/bin/bash

 pbip=`grep "IPADDR0" /etc/sysconfig/network-scripts/ifcfg-eth0`
 pbip=${pbip#*=}

 if [ -z "$pbip" ]; then
	     echo "이미 설정되어 있거나 잘못 설정되어 있습니다."
	         exit 1
 fi

 pbgw=`grep "GATEWAY0" /etc/sysconfig/network-scripts/ifcfg-eth0`
 pbgw=${pbgw#*=}

 pbpref=`grep "PREFIX0" /etc/sysconfig/network-scripts/ifcfg-eth0`
 pbpref=${pbpref#*=}
 echo $pbip / $pbgw / $pbpref 

 pvip=`grep "IPADDR1" /etc/sysconfig/network-scripts/ifcfg-eth0`
 pvip=${pvip#*=}

 pvpref=`grep "PREFIX1" /etc/sysconfig/network-scripts/ifcfg-eth0`
 pvpref=${pvpref#*=}
 pvpref=${pvpref//\"/}
 echo $pvip / $pvpref 

 cat << EOF > /etc/sysconfig/network-scripts/ifcfg-eth0
#Public Network
DEVICE=eth0
BOOTPROTO=none
ONBOOT=yes
IPADDR=$pbip
PREFIX=$pbpref
GATEWAY=$pbgw
EOF

cat << EOF > /etc/sysconfig/network-scripts/ifcfg-eth0:0
#private network
DEVICE=eth0:0
BOOTPROTO=none
ONBOOT=yes
IPADDR=$pvip
PREFIX=$pvpref
EOF

systemctl restart network
