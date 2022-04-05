ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:12.0
INSTALL_TARGET_PROCESSES = SpringBoard
GO_EASY_ON_ME = 1
THEOS_DEVICE_PORT = 2222
THEOS_DEVICE_IP = 127.0.0.1
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = relicloader
relicloader_FILES = Tweak.xm interface/XLLogerManager.m interface/XLLogerView.m interface/XLWindow.m interface/LocationPicker.m interface/LocationPickerAdvancedSettingsListViewController.m interface/LocationPickerView.m interface/LocationPickerViewController.m  interface/LocationPickerAdvancedSettingsView.m interface/LocationPickerSearchResultsViewController.m
relicloader_CFLAGS = -fobjc-arc -Iinclude -Iinterface -Wno-arc-performSelector-leaks -Wno-format-security -Wno-unused-function -Wno-unused-variable -Wno-deprecated-declarations
relicloader_EXTRA_FRAMEWORKS := CoreGraphics AssetsLibrary UIKit AVKit CoreFoundation QuartzCore MobileCoreServices AVFoundation CoreLocation MapKit
include $(THEOS_MAKE_PATH)/tweak.mk
