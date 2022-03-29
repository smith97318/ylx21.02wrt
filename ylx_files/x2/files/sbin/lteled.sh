#!/bin/sh 

echo "timer" > /sys/class/leds/lte1led/trigger
echo 500  > /sys/class/leds/lte1led/delay_off
echo 500  > /sys/class/leds/lte1led/delay_on

echo "timer" > /sys/class/leds/lte2led/trigger
echo 500  > /sys/class/leds/lte2led/delay_off
echo 500  > /sys/class/leds/lte2led/delay_on

sleep 8

echo "netdev" > /sys/class/leds/lte1led/trigger
echo "netdev" >  /sys/class/leds/lte2led/trigger

echo "$netdevice1" > /sys/class/leds/lte1led/device_name
echo "$netdevice2" > /sys/class/leds/lte2led/device_name

# 