################################################################################
#
# westeros-sink
#
################################################################################

WESTEROS_SINK_VERSION = 9633867603dcfb2a5c71af71e7e1abd12f0c2ca3
WESTEROS_SINK_SITE_METHOD = git
WESTEROS_SINK_SITE = git://github.com/Metrological/westeros
WESTEROS_SINK_INSTALL_STAGING = YES
WESTEROS_SINK_AUTORECONF = YES
WESTEROS_SINK_AUTORECONF_OPTS = "-Icfg"

WESTEROS_SINK_DEPENDENCIES = host-pkgconf host-autoconf wayland libegl

WESTEROS_SINK_CONF_OPTS += \
	--prefix=/usr/ \
    --disable-silent-rules \
    --disable-dependency-tracking \

ifeq ($(BR2_PACKAGE_MARVELL_AMPSDK),y)
	WESTEROS_SINK_CONF_OPTS += --enable-gstreamer1=yes \
			CFLAGS="$(TARGET_CFLAGS) -DLINUX -DEGL_API_FB -I ${STAGING_DIR}/usr/include/marvell/osal/include -I ${STAGING_DIR}/usr/include/marvell/amp/inc -D__LINUX__" \
			CXXFLAGS="$(TARGET_CXXFLAGS) -DLINUX -DEGL_API_FB -I ${STAGING_DIR}/usr/include/marvell/osal/include -I ${STAGING_DIR}/usr/include/marvell/amp/inc -D__LINUX__"
	WESTEROS_SINK_SUBDIR = syna/westeros-sink
endif

define WESTEROS_SINK_RUN_AUTOCONF
	mkdir -p $(@D)/$(WESTEROS_SINK_SUBDIR)/cfg
endef
WESTEROS_SINK_PRE_CONFIGURE_HOOKS += WESTEROS_SINK_RUN_AUTOCONF

define WESTEROS_SINK_ENTER_BUILD_DIR
	cd $(@D)/$(WESTEROS_SINK_SUBDIR)
endef
WESTEROS_SINK_PRE_BUILD_HOOKS += WESTEROS_SINK_ENTER_BUILD_DIR

$(eval $(autotools-package))
