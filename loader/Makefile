ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:13.0
INSTALL_TARGET_PROCESSES = SpringBoard
GO_EASY_ON_ME = 1
THEOS_DEVICE_PORT = 2222
THEOS_DEVICE_IP = 127.0.0.1
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = relicloader
relicloader_FILES = Tweak.xm
relicloader_CFLAGS = -fobjc-arc -Iinclude

include $(THEOS_MAKE_PATH)/tweak.mk
