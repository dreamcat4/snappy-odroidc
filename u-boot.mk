include common.mk

CC := /usr/bin/arm-linux-gnueabihf-

all: build

clean:
	if test -d "$(UBOOT_SRC)" ; then $(MAKE) ARCH=arm CROSS_COMPILE=${CC} -C $(UBOOT_SRC) clean ; fi
	rm -f $(UBOOT_BIN)

distclean:
	rm -rf $(wildcard $(UBOOT_SRC))

$(UBOOT_BIN): $(UBOOT_SRC)
	$(MAKE) ARCH=arm CROSS_COMPILE=${CC} -C $(UBOOT_SRC) odroidc_config
	$(MAKE) ARCH=arm CROSS_COMPILE=${CC} -C $(UBOOT_SRC) -j$(CPUS)
	touch $@

$(UBOOT_SRC):
	git clone --depth=1 $(UBOOT_REPO) -b $(UBOOT_BRANCH) u-boot

u-boot: $(UBOOT_BIN)

build: u-boot

.PHONY: u-boot build
