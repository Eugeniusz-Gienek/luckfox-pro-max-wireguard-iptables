# luckfox-pro-max-wireguard-iptables
Luckfox Pico Pro Max board - how to make it run Wireguard and iptables

Problematics
1. Luckfox Pico Pro Max can run Ubuntu 22.04.3 LTS BUT the kernel which is provided doesn't include modules and headers (custom 5.10.160)
2. The kernel is very poor in terms of network related features.
3. The update of kernel requires full re-flash of the board which is FAR from convenient

How did I overcome at least part of those issues (for reference, I use Luckfox Pico Pro Max with Ubuntu installed on 8Gb microsd card, or how they call it - TF card) - step by step.
1. Get their "SDK"( https://github.com/LuckfoxTECH/luckfox-pico ) and compile it:
   1. `git clone https://github.com/LuckfoxTECH/luckfox-pico.git`
   2. `cd luckfox-pico`
   3. `sudo ./build.sh lunch` (yup - not lAunch, but lunch - someone was pretty hungry there).
   4. Select `[5] RV1106_Luckfox_Pico_Max`
   5. edited kernel by the command `./build.sh kernelconfig` (You may use my kernel file 'luckfox_rv1106_linux_defconfig' and put it in here: `sysdrv/source/kernel/arch/arm/configs/luckfox_rv1106_linux_defconfig`
   6. `sudo ./build.sh`
   7. `cd output/image`
   8. `sudo -s`
   9. as mentioned on the manual page https://wiki.luckfox.com/Luckfox-Pico/Luckfox-Pico-RV1106/Luckfox-Pico-Pro-Max/Linux-MacOS-Burn-Image   - in the section "TF Card Image Flashing" download the file and unpack it: `wget https://files.luckfox.com/wiki/Luckfox-Pico/Software/blkenvflash.zip && unzip blkenvflash.zip`
   10. `chmod 755 blkenvflash`
   11. `chmod a+X blkenvflash`
   12. insert the microsd card in the reader and run this script to burn the firmware to microsd: `sudo ./blkenvflash /dev/mmcblk0` - where `/dev/mmcblk0` is a microsd card. The easiest way to find which device it is is to check dmesg: `dmesg | tail`; Also, make sure BEFORE running the firmware that Your microsd card doesn't have any partitions and if by accident Your OS didn't mount them. If so, unmount and run fdisk where remove all partitions - the easiest way possible.
   13. insert microsd card to the Luckfox Pico Pro Max and wait a minute
2. check on Your router / dns server / pihole / whatever which IP is assigned to the luckfox board.
3. `ssh pico@aaa.bbb.ccc.ddd`, where aaa.bbb.ccc.ddd is the IP adress from the previous step
4. password is "luckfox"
5. probably You want static IP so
   1. check if the ethernet is called eth0 or that fancy "blbrbrbdbs43765734"-whatever. Easiest way is just by running `ifconfig`. In my case it was just eth0.
   2. `sudo nano /etc/network/interfaces.d/eth0.conf`
   3. put there:
`auto eth0
iface eth0 inet static
        address aaa.bbb.ccc.ddd/24
        gateway eee.fff.ggg.hhh`
 - where aaa.bbb.ccc.ddd is a DESIRED IP, and the eee.fff.ggg.hhh is the IP address of Your gateway (usually router IP). They are supposed to be in the same network.
   4. edit DNS servers if needed: `sudo nano /etc/systemd/resolved.conf` - the line with "DNS=" is probably uncommented
   5. disable NetworkManager as it will interfere: `sudo systemctl disable NetworkManager`
   6. install necessary packages and then reboot: `sudo apt update && sudo apt install -y wireguard iptables mc && reboot`
6. from Your PC/laptop connect via SFTP in MC to the board and transfer there the modules compiled for this kernel - ".ko" ones from the folder `output/out/sysdrv_out/kernel_drv_ko/` in the luckfox-pico project directory
7. create the directory on luckfox "/ko": `sudo mkdir /ko` and move those files to that directory.
8. copy the 'insert_modules.sh' from this repo to the `/usr/local/sbin/` directory and adjust it according to the modules from there. The order is crucial. If errors happen when running insmod - `dmesg | tail` might help to udnerstand what is going on - e.g. "bla-bla is missing" - look for that .ko module and insmod it before Your one which shows an error etc.
9. `sudo chmod 755 /usr/local/sbin/insert_modules.sh && sudo chmod a+X /usr/local/sbin/insert_modules.sh`
10. copy the file "insert_kernel_modules.service" from this repo to `/etc/systemd/system/` folder
11. `sudo systemctl enable insert_kernel_modules.service`
12. `sudo reboot`

Wireguard should be working now and IPTables as well.
