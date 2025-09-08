PIVPN_VERSION = 4.11.0
PIVPN_SITE = https://github.com/pivpn/pivpn/archive/refs/tags
PIVPN_SOURCE = v$(PIVPN_VERSION).tar.gz
PIVPN_LICENSE = MIT
PIVPN_LICENSE_FILES = LICENSE
PIVPN_DEPENDENCIES = easy-rsa gawk getent grep grepcidr iptables iproute2 procps-ng net-tools util-linux sed systemd $(call qstrip,$(BR2_PACKAGE_PIVPN_BACKEND)) \
	findutils tar gzip

define PIVPN_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/opt/pivpn
	cp -a $(@D)/scripts/* $(TARGET_DIR)/opt/pivpn
	cp -a $(@D)/files $(TARGET_DIR)/opt/pivpn
	$(INSTALL) -D $(@D)/auto_install/install.sh $(TARGET_DIR)/usr/bin/pivpn-install

	ln -sf /opt/pivpn/$(call qstrip,$(BR2_PACKAGE_PIVPN_BACKEND))/pivpn.sh $(TARGET_DIR)/usr/bin/pivpn

	mkdir -p $(TARGET_DIR)/usr/local/src $(TARGET_DIR)/etc/openvpn
	ln -sf /opt/pivpn $(TARGET_DIR)/usr/local/src/pivpn

	$(INSTALL) -D -m 644 $(PIVPN_PKGDIR)/files/default-install-config $(TARGET_DIR)/etc/pivpn/default-install-config
endef

define PIVPN_INSTALL_INIT_SYSTEMD
	mkdir -p $(TARGET_DIR)/var/run/openvpn
	$(INSTALL) -D -m 644 $(PIVPN_PKGDIR)/files/pivpn.conf $(TARGET_DIR)/usr/lib/tmpfiles.d/
	$(INSTALL) -D -m 644 $(PIVPN_PKGDIR)/files/openvpn.service $(TARGET_DIR)/usr/lib/systemd/system
	$(INSTALL) -D -m 644 $(PIVPN_PKGDIR)/files/openvpn@.service $(TARGET_DIR)/usr/lib/systemd/system
	$(INSTALL) -D $(PIVPN_PKGDIR)/files/openvpn-generator $(TARGET_DIR)/usr/lib/systemd/system-generators
endef

define PIVPN_USERS
	openvpn 999 openvpn 999 * /var/lib/openvpn - - OpenVPN daemon user
	pivpn-adm -1 pivpn-adm -1 * /var/lib/pivpn-adm - - PiVPN admin user
endef

$(eval $(generic-package))
