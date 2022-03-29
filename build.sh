#!/bin/sh

#
lastbuild=`cat lastbuild`

btime=`date +%Y-%m-%d`
case $1 in
     x5)
         if [ "$lastbuild" = "x5" ];then
            echo "last build target is also x5"
         else
            rm -rf package/kernel/mac80211
            tar zxvf package/kernel/mac80211.ipq60xx.tar.gz -C package/kernel/
         fi
         echo x5 > lastbuild   
         rm -rf files
         cp ylx_files/x5/x5.config .config
         cp ylx_files/x5/files/ . -rf
         #cp logo/logo_linux_clut224.ppm.5g build_dir/target-aarch64_cortex-a53_musl/linux-ipq60xx_generic/linux-5.4.164/drivers/video/logo/logo_linux_clut224.ppm
         make V=s $2
         cp bin/targets/ipq60xx/generic/x5-21.02-v1.0-ipq60xx-generic-ylx_x5-squashfs-nand-factory.ubi firm/$btime-x5.bin
      ;;
      x2)
         if [ "$lastbuild" = "x5" ];then
            rm -rf package/kernel/mac80211
            tar zxvf package/kernel/mac80211.orig.tar.gz -C package/kernel/
         else
            echo "last build target is not x5"
         fi
         echo x2 > lastbuild

         cp ylx_files/x2/x2.config .config
         rm -rf files
         cp ylx_files/x2/files/ . -rf
         make V=s $2
         cp bin/targets/ath79/generic/openwrt-ath79-generic-ylx_x2-squashfs-sysupgrade.bin firm/$btime-x2.bin
         ;;
     *)
        echo "please input ./build.sh x5/x2 [-j4]."
        ;;
esac
