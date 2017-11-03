WPEFRAMEWORK_NETFLIX_VERSION = 3185d44931d81ef5034ddfc2cf197fc73e0b3617
WPEFRAMEWORK_NETFLIX_SITE_METHOD = git
WPEFRAMEWORK_NETFLIX_SITE = git@github.com:WebPlatformForEmbedded/WPEPluginNetflix.git
WPEFRAMEWORK_NETFLIX_INSTALL_STAGING = YES
WPEFRAMEWORK_NETFLIX_DEPENDENCIES = wpeframework netflix


WPEFRAMEWORK_NETFLIX_CONF_OPTS += -DBUILD_REFERENCE=${WPEFRAMEWORK_NETFLIX_VERSION}

ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_DEBUG),y)
# WPEFRAMEWORK_NETFLIX_CONF_OPTS += -DCMAKE_BUILD_TYPE=Debug
WPEFRAMEWORK_NETFLIX_CONF_OPTS += -DCMAKE_CXX_FLAGS='-g -Og'
endif

# TODO: Do not have WPEFRAMEWORK versioning yet
# WPEFRAMEWORK_NETFLIX_CONF_OPTS += -DWPEFRAMEWORK_PLUGIN_NETFLIX_VERSION="$(WEBBRIDGE_BUILD_VERSION)-dev"

ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_PLUGIN_NETFLIX_AUTOSTART),y)
WPEFRAMEWORK_NETFLIX_CONF_OPTS += -DWPEFRAMEWORK_PLUGIN_NETFLIX_AUTOSTART=true
else
WPEFRAMEWORK_NETFLIX_CONF_OPTS += -DWPEFRAMEWORK_PLUGIN_NETFLIX_AUTOSTART=false
endif

ifneq ($(BR2_PACKAGE_WPEFRAMEWORK_PLUGIN_NETFLIX_MODEL),)
WPEFRAMEWORK_NETFLIX_CONF_OPTS += -DWPEFRAMEWORK_PLUGIN_NETFLIX_MODEL="$(call qstrip,$(BR2_PACKAGE_WPEFRAMEWORK_PLUGIN_NETFLIX_MODEL))"
endif

ifneq ($(BR2_PACKAGE_WPEFRAMEWORK_PLUGIN_NETFLIX_SUSPEND_TIMEOUT),)
WPEFRAMEWORK_NETFLIX_CONF_OPTS += -DWPEFRAMEWORK_PLUGIN_NETFLIX_SUSPENDTIMEOUT="$(call qstrip,$(BR2_PACKAGE_WPEFRAMEWORK_PLUGIN_NETFLIX_SUSPEND_TIMEOUT))"
endif

ifneq ($(BR2_PACKAGE_WPEFRAMEWORK_PLUGIN_NETFLIX_RESUME_TIMEOUT),)
WPEFRAMEWORK_NETFLIX_CONF_OPTS += -DWPEFRAMEWORK_PLUGIN_NETFLIX_RESUMETIMEOUT="$(call qstrip,$(BR2_PACKAGE_WPEFRAMEWORK_PLUGIN_NETFLIX_RESUME_TIMEOUT))"
endif

$(eval $(cmake-package))

