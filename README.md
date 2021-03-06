# ODRDOID Snappy builder

Scripts to build [Ubuntu Snappy](http://developer.ubuntu.com/snappy/) OEM and device part for [ODROID C1](http://www.hardkernel.com/main/products/prdt_info.php?g_code=G141578608433).

## Requirements

To build all parts, a couple of dependencies are required. On Ubuntu you can
install all build dependencies with the following command.

```bash
sudo apt-get install build-essential u-boot-tools lzop debootstrap debootstrap gcc-arm-linux-gnueabihf
```

## Building

A `Makefile` is provided to build U-Boot, Kernel and Initrd from source. The
sources will be cloned into local folders if not there already. The U-Boot
provided by Hardkernel is lacking features to support Ubuntu Snappy and is
based on a very old U-Boot version. For now, i have backported the missing
required features in [my own U-Boot tree](https://github.com/longsleep/u-boot-odroidc).

To build it all, just run `make`. This will produce a oem snap `odroidc_x.y_all.snap`
and a `device-odroidc.tar.gz` device part, which can be used to build your own
Ubuntu Snappy image for ODROID C1.

### Build OEM snap

You can build the OEM snap seperately too. The OEM snap contains the U-Boot,
so make sure you have build the U-Boot first with `make u-boot`.

```bash
make oem
```

The OEM snap, contains also a boot.ini which overwrites certain variables to
make Snappy work with the U-Boot v2011.03. This is quite hacky but for now
seems to be the only possible option. In addition, the OEM snap contains the
binary proprietary boot loader code which bootstraps the SOC. On build, this
boot code is split up as required by the hardware platform.

### Build device part

Of course the device part can be built seperately as well. The device part
contains the Linux kernel and modules, so make sure to have built the Linux
Kernel first with `make linux`.

```bash
make device
```
The device part is quite straigt forward. It contains the linux Kernel in the
U-Boot compatible format, the compiled device tree, the Kernel modules and the
initial ram disk. As there does not seem to be any reasonable way to build the
initrd, it is extracted from the preinstalled Ubuntu Snappy Core tar and
repacked without Kernel and  modules. We do not add any Kernel modules to the
ram disk.

## Build Snappy image for ODROID C1

Make sure you have build the OEM snap and the device part first. Then you can
simply create the image like this.

```bash
sudo ubuntu-device-flash core 15.04 \
	--oem odroidc_x.y_all.snap \
	--device-part device-odroidc.tar.xz \
	--developer-mode \
	-s 3 \
	-o odroidc.img
```

Flash this to SD or eMMC and your ODROID will boot into Snappy. Default user
is `ubuntu` with password `ubuntu`.

Enjoy!

--
Simon Eisenmann <simon@longsleep.org>