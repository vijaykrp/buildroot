################################################################################
#
# bluez5_utils
#
################################################################################
ifeq ($(BR2_PACKAGE_MARVELL_AMPSDK),y)
BLUEZ5_UTILS_VERSION = 5.28
else
BLUEZ5_UTILS_VERSION = 5.44
endif

BLUEZ5_UTILS_SOURCE = bluez-$(BLUEZ5_UTILS_VERSION).tar.xz
BLUEZ5_UTILS_SITE = $(BR2_KERNEL_MIRROR)/linux/bluetooth
BLUEZ5_UTILS_INSTALL_STAGING = YES
BLUEZ5_UTILS_DEPENDENCIES = dbus libglib2
BLUEZ5_UTILS_LICENSE = GPLv2+, LGPLv2.1+
BLUEZ5_UTILS_LICENSE_FILES = COPYING COPYING.LIB

BLUEZ5_UTILS_CONF_OPTS = 	\
	--enable-tools 		\
	--enable-library 	\
	--disable-cups

BLUEZ5_UTILS_DEPENDENCIES += host-python

ifeq ($(BR2_PACKAGE_BLUEZ5_UTILS_OBEX),y)
BLUEZ5_UTILS_CONF_OPTS += --enable-obex
BLUEZ5_UTILS_DEPENDENCIES += libical
else
BLUEZ5_UTILS_CONF_OPTS += --disable-obex
endif

ifeq ($(BR2_PACKAGE_BLUEZ5_UTILS_CLIENT),y)
BLUEZ5_UTILS_CONF_OPTS += --enable-client
BLUEZ5_UTILS_DEPENDENCIES += readline
else
BLUEZ5_UTILS_CONF_OPTS += --disable-client
endif

# experimental plugins
ifeq ($(BR2_PACKAGE_BLUEZ5_UTILS_EXPERIMENTAL),y)
BLUEZ5_UTILS_CONF_OPTS += --enable-experimental
else
BLUEZ5_UTILS_CONF_OPTS += --disable-experimental
endif

# enable sixaxis plugin
ifeq ($(BR2_PACKAGE_BLUEZ5_PLUGINS_SIXAXIS),y)
BLUEZ5_UTILS_CONF_OPTS += --enable-sixaxis
else
BLUEZ5_UTILS_CONF_OPTS += --disable-sixaxis
endif

# install gatttool (For some reason upstream choose not to do it by default)
ifeq ($(BR2_PACKAGE_BLUEZ5_UTILS_GATTTOOL),y)
define BLUEZ5_UTILS_INSTALL_GATTTOOL
	$(INSTALL) -D -m 0755 $(@D)/attrib/gatttool $(TARGET_DIR)/usr/bin/gatttool
endef
BLUEZ5_UTILS_POST_INSTALL_TARGET_HOOKS += BLUEZ5_UTILS_INSTALL_GATTTOOL
endif

# enable test
ifeq ($(BR2_PACKAGE_BLUEZ5_UTILS_TEST),y)
BLUEZ5_UTILS_CONF_OPTS += --enable-test
else
BLUEZ5_UTILS_CONF_OPTS += --disable-test
endif

# use udev if available
ifeq ($(BR2_PACKAGE_HAS_UDEV),y)
BLUEZ5_UTILS_CONF_OPTS += --enable-udev
BLUEZ5_UTILS_DEPENDENCIES += udev
else
BLUEZ5_UTILS_CONF_OPTS += --disable-udev
endif

# integrate with systemd if available
ifeq ($(BR2_PACKAGE_SYSTEMD),y)
BLUEZ5_UTILS_CONF_OPTS += --enable-systemd
BLUEZ5_UTILS_DEPENDENCIES += systemd
else
BLUEZ5_UTILS_CONF_OPTS += --disable-systemd
endif

BLUEZ5_UTILS_PKGDIR = "$(TOP_DIR)/package/bluez5_utils"
define BLUEZ5_UTILS_APPLY_LOCAL_PATCHES
        $(APPLY_PATCHES) $(@D) $(BLUEZ5_UTILS_PKGDIR) 0001-tools-bneptest.c-Remove-include-linux-if_bridge.h-to.patch.conditional;
endef
ifneq ($(BR2_PACKAGE_MARVELL_AMPSDK),y)
BLUEZ5_UTILS_POST_PATCH_HOOKS += BLUEZ5_UTILS_APPLY_LOCAL_PATCHES
endif

define BLUEZ5_UTILS_INSTALL_INIT_SYSTEMD
	mkdir -p $(TARGET_DIR)/etc/systemd/system/bluetooth.target.wants
	ln -fs ../../../../usr/lib/systemd/system/bluetooth.service \
		$(TARGET_DIR)/etc/systemd/system/bluetooth.target.wants/bluetooth.service
	ln -fs ../../../../usr/lib/systemd/system/bluetooth.service \
		$(TARGET_DIR)/etc/systemd/system/dbus-org.bluez.service
endef

$(eval $(autotools-package))
