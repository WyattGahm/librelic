ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:13.0
ADDITIONAL_OBJCFLAGS = -fobjc-exceptions
GO_EASY_ON_ME = 1
THEOS_DEVICE_PORT = 2222
THEOS_DEVICE_IP = 127.0.0.1


LIBRARY_NAME = librelic
librelic_FRAMEWORKS = Foundation UIKit
librelic_FILES = hashmap.mm relic.mm

SUBPROJECTS += loader

librelic_LIBRARIES = substrate

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/library.mk

after-install::
	install.exec "killall -9 SpringBoard"
