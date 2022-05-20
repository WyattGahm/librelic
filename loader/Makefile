ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:12.0
GO_EASY_ON_ME = 1
THEOS_DEVICE_PORT = 2222
THEOS_DEVICE_IP = 127.0.0.1
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = relicloader
relicloader_FILES = Tweak.xm $(wildcard interface/*/*.*m)
relicloader_CFLAGS += -fobjc-arc -Iinclude -Iinterface/Shadow -Iinterface/LocationPicker -Iinterface/RainbowRoad -Iinterface/XLLogger
relicloader_CFLAGS += -Wno-arc-performSelector-leaks -Wno-format-security -Wno-unused-function -Wno-unused-variable -Wno-deprecated-declarations
relicloader_CFLAGS += -DSHADOW_VERSION='"3.2.8"'
relicloader_CFLAGS += -DSHADOW_PROJECT='"relicloader"'
relicloader_CFLAGS += -DSERVER='@"http://144.172.67.132:42069"'
relicloader_EXTRA_FRAMEWORKS := CoreGraphics AssetsLibrary UIKit AVKit CoreFoundation QuartzCore MobileCoreServices AVFoundation CoreLocation MapKit
include $(THEOS_MAKE_PATH)/tweak.mk
