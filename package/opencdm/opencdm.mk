################################################################################
#
# cdm
#
################################################################################
OPENCDM_VERSION = 4ad09b0781d6c7c18cbc725eeec1b3b663b8c542
OPENCDM_SITE_METHOD = git
OPENCDM_SITE = https://github.com/WebPlatformForEmbedded/WPEOpenCDM.git

OPENCDM_INSTALL_STAGING = YES
OPENCDMI_LICENSE = Apache-2.0
OPENCDMI_LICENSE_FILES = LICENSE

#Apply WPE specific patches using opencdm.patch

#Build
define OPENCDM_BUILD_CMDS
    export OPENCDM_TARGET_DIR="$(TARGET_DIR)";\
    export OPENCDM_STAGING_DIR="$(STAGING_DIR)";\
    make CROSS_COMPILE="$(TARGET_CROSS)" \
    CC="$(TARGET_CC)" CXX="$(TARGET_CXX)" AR="$(TARGET_AR)" \
    CXXFLAGS="$(TARGET_CXXFLAGS)" \
    LDFLAGS="$(TARGET_LDFLAGS)  -L$(STAGING_DIR)/usr/lib  -pthread" -C $(@D)
endef

define OPENCDM_INSTALL_TARGET_CMDS
    cp $(@D)/src/browser/wpe/bin/ocdm_client $(TARGET_DIR)/usr/bin
    cp $(@D)/src/browser/wpe/bin/ocdm_decryptor $(TARGET_DIR)/usr/bin
    cp $(@D)/src/browser/wpe/lib/libocdm.so $(TARGET_DIR)/usr/lib
endef
define OPENCDM_INSTALL_STAGING_CMDS
    cp $(@D)/src/browser/wpe/lib/libocdm.so $(STAGING_DIR)/usr/lib
    mkdir -p $(STAGING_DIR)/usr/include/opencdm
    cp -r $(@D)/src/browser/wpe/include/* $(STAGING_DIR)/usr/include/opencdm
endef

$(eval $(generic-package))
$(eval $(host-generic-package))
