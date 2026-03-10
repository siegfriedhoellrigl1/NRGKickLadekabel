#!/bin/bash

#fake=1

#if test "$USER" != "www-data";then
if test "$LOGNAME" != "www-data" && test "$USER" != "www-data" ;then
 echo bitte nur als www-data ausführen
 echo su -s /bin/bash -c /www/ladekabel.sh - www-data
 exit 0
fi

if test "$fake" == "1"; then
 imax=14
 if test "$1" != ""; then
  echo Setze auf $1
  imax="$1"
 fi
 echo Total Energy 230454

 echo Energy 3928

 echo L1 200V 14.999A 3780W
 echo L2 200V 0.001A 1.001W
 echo L3 201V 0.002A 0.002W


 echo Ladestrom ${imax}A
 echo $1 >> /tmp/ladekabel.log

 exit 0
fi

source /www/.ladekabel.cred

if test "$(ping -c 1 -t 1 $ip | grep from | wc -l)" -eq 0; then
 echo "Keine Verbindung."
 exit 0
fi

if test "$1" != ""; then
 if test "$1" -lt 6; then
  curl -s -u "$user:$pw"  "http://$ip/control?charge_pause=1" > /dev/null
  /www/nachricht_info.sh "$2 Ladekabel aus."
  echo 0 > /tmp/ladekabel.angesteckt
 else
  control=$(curl -s -u "$user:$pw"  http://$ip/control)
  paus=$(echo $control|jq '.charge_pause')
  if test "$paus" == "1"; then
   curl -s -u "$user:$pw"  "http://$ip/control?charge_pause=0" > /dev/null
   echo 0 > /tmp/ladekabel.angesteckt
  fi
  curl -s -u "$user:$pw"  "http://$ip/control?current_set=$1" > /dev/null
  /www/nachricht_info.sh "$2 Ladekabel ${1}A"
  echo 0 > /tmp/ladekabel.angesteckt
 fi
fi


#info=$(curl -s -u "$user:$pw"  http://$ip/info)

values=$(curl -s -u "$user:$pw"  http://$ip/values)
control=$(curl -s -u "$user:$pw"  http://$ip/control)



paus=$(echo $control|jq '.charge_pause')




total_energy=$(echo $values|jq '.energy.total_charged_energy')

energy=$(echo $values|jq '.energy.charged_energy')

imax=$(echo $values|jq '.powerflow.charging_current')

p1=$(echo $values|jq '.powerflow.l1.active_power')
u1=$(echo $values|jq '.powerflow.l1.voltage')
i1=$(echo $values|jq '.powerflow.l1.current')
p2=$(echo $values|jq '.powerflow.l2.active_power')
u2=$(echo $values|jq '.powerflow.l2.voltage')
i2=$(echo $values|jq '.powerflow.l2.current')
p3=$(echo $values|jq '.powerflow.l3.active_power')
u3=$(echo $values|jq '.powerflow.l3.voltage')
i3=$(echo $values|jq '.powerflow.l3.current')

t_l1=$(echo "$values"|jq '.temperatures.connector_l1')
t_l2=$(echo "$values"|jq '.temperatures.connector_l2')
t_l3=$(echo "$values"|jq '.temperatures.connector_l3')
t_ho=$(echo "$values"|jq '.temperatures.housing')

echo Total Energy $total_energy

echo Energy $energy

echo L1 ${u1}V ${i1}A ${p1}W
echo L2 ${u2}V ${i2}A ${p2}W
echo L3 ${u3}V ${i3}A ${p3}W

if test "$paus" == "0"; then
 echo Ladestrom ${imax}A
else
 echo Ladestrom 0A
fi

#echo Pause $paus


echo Temperatur L1 L2 L3 Gehaeuse $t_l1 $t_l2 $t_l3 $t_ho

