#!/bin/bash
cd /ko
insmod libcurve25519-generic.ko
insmod poly1305-arm.ko
insmod chacha-neon.ko
insmod libchacha20poly1305.ko
insmod wireguard.ko
###############################
insmod xt_TCPMSS.ko
insmod cfg80211.ko
#insmod libaes.ko
#insmod aes_generic.ko
insmod blake2s-arm.ko
insmod cmac.ko
insmod configs.ko
insmod ctr.ko
insmod gcm.ko
#insmod gf128mul.ko
insmod ghash-generic.ko
insmod gspca_main.ko
insmod kheaders.ko
insmod libarc4.ko
insmod libcurve25519.ko
insmod mac80211.ko
insmod phy-rockchip-csi2-dphy-hw.ko
insmod phy-rockchip-csi2-dphy.ko
insmod rga3.ko
insmod rk_dvbm.ko
insmod rknpu.ko
insmod rve.ko
insmod sc3336.ko
insmod video_rkcif.ko
insmod video_rkisp.ko
insmod mpp_vcodec.ko
insmod rockit.ko
insmod ccm.ko