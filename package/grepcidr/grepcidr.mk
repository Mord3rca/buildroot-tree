GREPCIDR_VERSION = master
GREPCIDR_SITE = https://github.com/pivpn/grepcidr/archive
GREPCIDR_SOURCE = master.tar.gz
GREPCIDR_LICENSE = GPL-2

define GREPCIDR_BUILD_CMDS
	$(MAKE) -C $(@D) CC=$(TARGET_CC)
endef

define GREPCIDR_INSTALL_TARGET_CMDS
	$(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR) PREFIX=/usr install
endef

$(eval $(generic-package))
