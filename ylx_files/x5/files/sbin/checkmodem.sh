#!/bin/sh

path13="/sys/devices/platform/soc/8af8800.usb3/8a00000.dwc3/xhci-hcd.1.auto/usb4/4-1/4-1.2"
path12="/sys/devices/platform/soc/8af8800.usb3/8a00000.dwc3/xhci-hcd.1.auto/usb3/3-1/3-1.2"

path23="/sys/devices/platform/soc/8af8800.usb3/8a00000.dwc3/xhci-hcd.1.auto/usb4/4-1/4-1.4"
path22="/sys/devices/platform/soc/8af8800.usb3/8a00000.dwc3/xhci-hcd.1.auto/usb3/3-1/3-1.4"

path33="/sys/devices/platform/soc/8af8800.usb3/8a00000.dwc3/xhci-hcd.1.auto/usb4/4-1/4-1.3"
path32="/sys/devices/platform/soc/8af8800.usb3/8a00000.dwc3/xhci-hcd.1.auto/usb3/3-1/3-1.3"

path42="/sys/devices/platform/soc/70f8800.usb2/7000000.dwc3/xhci-hcd.0.auto/usb1/1-1"

dev1="NULL"
dev2="NULL"
dev3="NULL"
dev4="NULL"
netdevice1="NULL"
netdevice2="NULL"
netdevice3="NULL"
netdevice4="NULL"

if ls $path13 > /dev/null 2>&1;then
    pid1=`cat $path13/idProduct`
elif ls $path12 > /dev/null 2>&1;then
    pid1=`cat $path12/idProduct`
else
    pid1=
fi

if ls $path23 > /dev/null 2>&1;then
    pid2=`cat $path23/idProduct`
elif ls $path22 > /dev/null 2>&1;then
    pid2=`cat $path22/idProduct`
else
    pid2=
fi

if ls $path33 > /dev/null 2>&1;then
    pid3=`cat $path33/idProduct`
elif ls $path32 > /dev/null 2>&1;then
    pid3=`cat $path32/idProduct`
else
    pid3=
fi

if ls $path42 > /dev/null 2>&1;then
    pid4=`cat $path42/idProduct`
else
    pid4=
fi

# echo pid1:$pid1,pid2:$pid2,pid3:$pid3,pid4:$pid4


[ -n "$pid1" ] && {
     case $pid1 in
        4d22)
            netdevice1=`ls $path13/${path13##*/}:1.5/net`
            DEVICENAME1=`ls $path13/${path13##*/}:1.2/|grep ttyUSB`
            dev1="/dev/$DEVICENAME1"
            uci set config4g.4G.tty="$dev1"
            uci set config4g.4G.tool='quectel-CM'
            uci delete config4g.4G.atcmd
            uci commit config4g
            ;;
        90d5)
            netdevice1=`ls $path13/${path13##*/}:1.2/net`
            DEVICENAME1=`ls $path13/${path13##*/}:1.5/|grep ttyUSB`
            dev1="/dev/$DEVICENAME1"
            uci set config4g.4G.tty="$dev1"
            uci set config4g.4G.tool='quectel-CM'
            uci delete config4g.4G.atcmd
            uci commit config4g
            ;;
        0a05)
            netdevice1=`ls $path13/${path13##*/}:1.0/net`
            DEVICENAME1=`ls $path13/${path13##*/}:1.3/|grep ttyUSB`
            dev1="/dev/$DEVICENAME1"
            uci set config4g.4G.tty="$dev1"
            uci set config4g.4G.tool='at'
            uci set config4g.4G.atcmd="AT+GTRNDIS=1,1"
            uci commit config4g
            ;;
        0900)
            netdevice1=`ls $path13/${path13##*/}:1.0/net`
            DEVICENAME1=`ls $path13/${path13##*/}:1.4/|grep ttyUSB`
            dev1="/dev/$DEVICENAME1"
            uci set config4g.4G.tty="$dev1"
            uci set config4g.4G.tool='at'
            uci set config4g.4G.atcmd="AT+QNETDEVCTL=1,1,1"
            uci commit config4g
			;;
        0125) #usb2.0 not the same path
			netdevice1=`ls $path12/${path12##*/}:1.4/net`
            DEVICENAME1=`ls $path12/${path12##*/}:1.2/|grep ttyUSB`
            dev1="/dev/$DEVICENAME1"
            uci set config4g.4G.tty="$dev1"
            uci set config4g.4G.tool='quectel-CM'
            uci delete config4g.4G.atcmd
            uci commit config4g
			;;
        030a) #em05-g
			netdevice1=`ls $path12/${path12##*/}:1.6/net`
            DEVICENAME1=`ls $path12/${path12##*/}:1.2/|grep ttyUSB`
            dev1="/dev/$DEVICENAME1"
            uci set config4g.4G.tty="$dev1"
            uci set config4g.4G.tool='quectel-CM'
            uci delete config4g.4G.atcmd
            uci commit config4g
			;;
		9001) 
			netdevice1=`ls $path12/${path12##*/}:1.5/net`
            DEVICENAME1=`ls $path12/${path12##*/}:1.2/|grep ttyUSB`
            dev1="/dev/$DEVICENAME1"
            uci set config4g.4G.tty="$dev1"
            uci set config4g.4G.tool='quectel-CM'
            uci delete config4g.4G.atcmd
            uci commit config4g
			;;

    esac
}

[ -n "$pid2" ] && {
     case $pid2 in
        4d22)
            netdevice2=`ls $path23/${path23##*/}:1.5/net`
            DEVICENAME2=`ls $path23/${path23##*/}:1.2/|grep ttyUSB`
            dev2="/dev/$DEVICENAME2"
            uci set config4g.4G1.tty="$dev2"
            uci set config4g.4G1.tool='quectel-CM'
            uci delete config4g.4G1.atcmd
            uci commit config4g
            ;;
        90d5)
            netdevice2=`ls $path23/${path23##*/}:1.2/net`
            DEVICENAME2=`ls $path23/${path23##*/}:1.5/|grep ttyUSB`
            dev2="/dev/$DEVICENAME2"
            uci set config4g.4G1.tty="$dev2"
            uci set config4g.4G1.tool='quectel-CM'
            uci delete config4g.4G1.atcmd
            uci commit config4g
            ;;
        0a05)
            netdevice2=`ls $path23/${path23##*/}:1.0/net`
            DEVICENAME2=`ls $path23/${path23##*/}:1.3/|grep ttyUSB`
            dev2="/dev/$DEVICENAME2"
            uci set config4g.4G1.tty="$dev2"
            uci set config4g.4G1.tool='at'
            uci set config4g.4G1.atcmd="AT+GTRNDIS=1,1"
            uci commit config4g
            ;;
        0900)
            netdevice2=`ls $path23/${path23##*/}:1.0/net`
            DEVICENAME2=`ls $path23/${path23##*/}:1.4/|grep ttyUSB`
            dev2="/dev/$DEVICENAME2"
            uci set config4g.4G1.tty="$dev2"
            uci set config4g.4G1.tool='at'
            uci set config4g.4G1.atcmd="AT+QNETDEVCTL=1,1,1"
            uci commit config4g
			;;
        0125) #usb2.0 not the same path
			netdevice2=`ls $path22/${path22##*/}:1.4/net`
            DEVICENAME2=`ls $path22/${path22##*/}:1.2/|grep ttyUSB`
            dev2="/dev/$DEVICENAME2"
            uci set config4g.4G1.tty="$dev2"
            uci set config4g.4G1.tool='quectel-CM'
            uci delete config4g.4G1.atcmd
            uci commit config4g
			;;
        030a) #em05-g
			netdevice2=`ls $path22/${path22##*/}:1.6/net`
            DEVICENAME2=`ls $path22/${path22##*/}:1.2/|grep ttyUSB`
            dev2="/dev/$DEVICENAME2"
            uci set config4g.4G1.tty="$dev2"
            uci set config4g.4G1.tool='quectel-CM'
            uci delete config4g.4G1.atcmd
            uci commit config4g
			;;
		9001) 
			netdevice2=`ls $path22/${path22##*/}:1.5/net`
            DEVICENAME2=`ls $path22/${path22##*/}:1.2/|grep ttyUSB`
            dev2="/dev/$DEVICENAME2"
            uci set config4g.4G1.tty="$dev2"
            uci set config4g.4G1.tool='quectel-CM'
            uci delete config4g.4G1.atcmd
            uci commit config4g
			;;
    esac
}

[ -n "$pid3" ] && {
     case $pid3 in
        4d22)
            netdevice3=`ls $path33/${path33##*/}:1.5/net`
            DEVICENAME3=`ls $path33/${path33##*/}:1.2/|grep ttyUSB`
            dev3="/dev/$DEVICENAME3"
            uci set config4g.4G2.tty="$dev3"
            uci set config4g.4G2.tool='quectel-CM'
            uci delete config4g.4G2.atcmd
            uci commit config4g
            ;;
        90d5)
            netdevice3=`ls $path33/${path33##*/}:1.2/net`
            DEVICENAME3=`ls $path33/${path33##*/}:1.5/|grep ttyUSB`
            dev3="/dev/$DEVICENAME3"
            uci set config4g.4G2.tty="$dev3"
            uci set config4g.4G2.tool='quectel-CM'
            uci delete config4g.4G2.atcmd
            uci commit config4g
            ;;
        0a05)
            netdevice3=`ls $path33/${path33##*/}:1.0/net`
            DEVICENAME3=`ls $path33/${path33##*/}:1.3/|grep ttyUSB`
            dev3="/dev/$DEVICENAME3"
            uci set config4g.4G2.tty="$dev3"
            uci set config4g.4G2.tool='at'
            uci set config4g.4G2.atcmd="AT+GTRNDIS=1,1"
            uci commit config4g
            ;;
        0900)
            netdevice3=`ls $path33/${path33##*/}:1.0/net`
            DEVICENAME3=`ls $path33/${path33##*/}:1.4/|grep ttyUSB`
            dev1="/dev/$DEVICENAME3"
            uci set config4g.4G2.tty="$dev3"
            uci set config4g.4G2.tool='at'
            uci set config4g.4G2.atcmd="AT+QNETDEVCTL=1,1,1"
            uci commit config4g
			;;
        0125) #usb2.0 not the same path
			netdevice3=`ls $path32/${path32##*/}:1.4/net`
            DEVICENAME3=`ls $path32/${path32##*/}:1.2/|grep ttyUSB`
            dev3="/dev/$DEVICENAME3"
            uci set config4g.4G2.tty="$dev3"
            uci set config4g.4G2.tool='quectel-CM'
            uci delete config4g.4G2.atcmd
            uci commit config4g
			;;
        030a) #em05-g
			netdevice3=`ls $path32/${path32##*/}:1.6/net`
            DEVICENAME3=`ls $path32/${path32##*/}:1.2/|grep ttyUSB`
            dev3="/dev/$DEVICENAME3"
            uci set config4g.4G2.tty="$dev3"
            uci set config4g.4G2.tool='quectel-CM'
            uci delete config4g.4G2.atcmd
            uci commit config4g
			;;
		9001) 
			netdevice3=`ls $path32/${path32##*/}:1.5/net`
            DEVICENAME3=`ls $path32/${path32##*/}:1.2/|grep ttyUSB`
            dev3="/dev/$DEVICENAME3"
            uci set config4g.4G2.tty="$dev3"
            uci set config4g.4G2.tool='quectel-CM'
            uci delete config4g.4G2.atcmd
            uci commit config4g
			;;
    esac
}

[ -n "$pid4" ] && {
     case $pid4 in
        0125) #usb2.0 not the same path
			netdevice4=`ls $path42/${path42##*/}:1.4/net`
            DEVICENAME4=`ls $path42/${path42##*/}:1.2/|grep ttyUSB`
            dev4="/dev/$DEVICENAME4"
            uci set config4g.4G3.tty="$dev4"
            uci set config4g.4G3.tool='quectel-CM'
            uci delete config4g.4G3.atcmd
            uci commit config4g
			;;
        030a) ##em05-g
			netdevice4=`ls $path42/${path42##*/}:1.6/net`
            DEVICENAME4=`ls $path42/${path42##*/}:1.2/|grep ttyUSB`
            dev4="/dev/$DEVICENAME4"
            uci set config4g.4G3.tty="$dev4"
            uci set config4g.4G3.tool='quectel-CM'
            uci delete config4g.4G3.atcmd
            uci commit config4g
			;;
		9001) 
			netdevice4=`ls $path42/${path42##*/}:1.5/net`
            DEVICENAME4=`ls $path42/${path42##*/}:1.2/|grep ttyUSB`
            dev4="/dev/$DEVICENAME4"
            uci set config4g.4G3.tty="$dev4"
            uci set config4g.4G3.tool='quectel-CM'
            uci delete config4g.4G3.atcmd
            uci commit config4g
			;;
    esac
}
# echo netdevice1:$netdevice1,netdevice2:$netdevice2,netdevice3:$netdevice3,netdevice4:$netdevice4

uci set config4g.4G.netdevice="$netdevice1"
uci set /etc/config/lte_info.card1.ethName="$netdevice1"
if [ "$pid1" = "4d22" ];then
    uci set network.lte1.device="${netdevice1}_1"
else
    uci set network.lte1.device="${netdevice1}"
fi

uci set config4g.4G1.netdevice="$netdevice2"
uci set /etc/config/lte_info.card2.ethName="$netdevice2"
if [ "$pid2" = "4d22" ];then
    uci set network.lte2.device="${netdevice2}_1"
else
    uci set network.lte2.device="${netdevice2}"
fi

uci set config4g.4G2.netdevice="$netdevice3"
uci set /etc/config/lte_info.card3.ethName="$netdevice3"
if [ "$pid3" = "4d22" ];then
    uci set network.lte3.device="${netdevice3}_1"
else
    uci set network.lte3.device="${netdevice3}"
fi

uci set config4g.4G3.netdevice="$netdevice4"
uci set /etc/config/lte_info.card4.ethName="$netdevice4"
if [ "$pid4" = "4d22" ];then
    uci set network.lte4.device="${netdevice4}_1"
else
    uci set network.lte4.device="${netdevice4}"
fi

# echo dev1:$dev1,dev2:$dev2,dev3:$dev3,dev4:$dev4

uci set /etc/config/lte_info.card1.ttyName="$dev1"
uci set 4g.modem1.device="$dev1"
uci set /etc/config/lte_info.card2.ttyName="$dev2"
uci set 4g.modem2.device="$dev2"
uci set /etc/config/lte_info.card3.ttyName="$dev3"
uci set 4g.modem3.device="$dev3"
uci set /etc/config/lte_info.card4.ttyName="$dev4"
uci set 4g.modem4.device="$dev4"

uci commit 4g
uci commit lte_info
uci commit config4g
uci commit network
cp /etc/config/lte_info /tmp/lte_info
/etc/init.d/config4g restart
/etc/init.d/net_ttyipq restart
/etc/init.d/shadowsocks-libev restart
/etc/init.d/lv_exampleipq restart


