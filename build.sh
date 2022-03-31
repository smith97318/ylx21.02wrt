#!/bin/sh

#
lastbuild=`cat lastbuild`

btime=`date +%Y-%m-%d`
case $1 in
     x5)
         if [ "$lastbuild" = "ipq60xx" ];then
            echo "last build target is also ipq60xx"
         else
            rm -rf package/kernel/mac80211
            tar zxvf package/kernel/mac80211.ipq60xx.tar.gz -C package/kernel/
         fi
         echo "ipq60xx" > lastbuild   
         rm -rf files
         cp ylx_files/x5/x5.config .config
         cp ylx_files/x5/files/ . -rf
         #cp logo/logo_linux_clut224.ppm.5g build_dir/target-aarch64_cortex-a53_musl/linux-ipq60xx_generic/linux-5.4.164/drivers/video/logo/logo_linux_clut224.ppm
         make V=s $2
         cp bin/targets/ipq60xx/generic/x5-21.02-v1.0-ipq60xx-generic-ylx_x5-squashfs-nand-factory.ubi firm/$btime-x5.bin
      ;;
      x511)
         if [ "$lastbuild" = "ipq60xx" ];then
            echo "last build target is also ipq60xx"
         else
            rm -rf package/kernel/mac80211
            tar zxvf package/kernel/mac80211.ipq60xx.tar.gz -C package/kernel/
         fi
         echo "ipq60xx" > lastbuild   
         rm -rf files
         cp ylx_files/x511/x511.config .config
         cp ylx_files/x511/files/ . -rf
         #cp logo/logo_linux_clut224.ppm.5g build_dir/target-aarch64_cortex-a53_musl/linux-ipq60xx_generic/linux-5.4.164/drivers/video/logo/logo_linux_clut224.ppm
         make V=s $2
         cp bin/targets/ipq60xx/generic/x511-21.02-v1.0-ipq60xx-generic-ylx_x511-squashfs-nand-factory.ubi firm/$btime-x511.bin
      ;;
      q60)
         if [ "$lastbuild" = "ipq60xx" ];then
            echo "last build target is also ipq60xx"
         else
            rm -rf package/kernel/mac80211
            tar zxvf package/kernel/mac80211.ipq60xx.tar.gz -C package/kernel/
         fi
         echo "ipq60xx" > lastbuild   
         rm -rf files
         cp ylx_files/q60/q60.config .config
         cp ylx_files/q60/files/ . -rf
         #cp logo/logo_linux_clut224.ppm.5g build_dir/target-aarch64_cortex-a53_musl/linux-ipq60xx_generic/linux-5.4.164/drivers/video/logo/logo_linux_clut224.ppm
         make V=s $2
         cp bin/targets/ipq60xx/generic/q60-21.02-v1.0-ipq60xx-generic-ylx_q60-squashfs-nand-factory.ubi firm/$btime-q60.bin
      ;;
      x8)
         if [ "$lastbuild" = "ipq60xx" ];then
            echo "last build target is also ipq60xx"
         else
            rm -rf package/kernel/mac80211
            tar zxvf package/kernel/mac80211.ipq60xx.tar.gz -C package/kernel/
         fi
         echo "ipq60xx" > lastbuild   
         rm -rf files
         cp ylx_files/x8/x8.config .config
         cp ylx_files/x8/files/ . -rf
         #cp logo/logo_linux_clut224.ppm.5g build_dir/target-aarch64_cortex-a53_musl/linux-ipq60xx_generic/linux-5.4.164/drivers/video/logo/logo_linux_clut224.ppm
         make V=s $2
         cp bin/targets/ipq60xx/generic/x8-21.02-v1.0-ipq60xx-generic-ylx_x8-squashfs-nand-factory.ubi firm/$btime-x8.bin
      ;;
      x2)
         if [ "$lastbuild" = "ipq60xx" ];then
            rm -rf package/kernel/mac80211
            tar zxvf package/kernel/mac80211.orig.tar.gz -C package/kernel/
         else
            echo "last build target is not x5"
         fi
         echo "ath79" > lastbuild

         cp ylx_files/x2/x2.config .config
         rm -rf files
         cp ylx_files/x2/files/ . -rf
         make V=s $2
         cp bin/targets/ath79/generic/x2-21.02-v1.0-ath79-generic-ylx_x2-squashfs-sysupgrade.bin firm/$btime-x2.bin
         ;;
     *)
        echo "please input ./build.sh x5/x511/q60/x8/x2 [-j4]."
        ;;
esac
