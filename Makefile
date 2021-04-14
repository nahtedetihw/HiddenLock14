export TARGET := iphone:clang:latest
INSTALL_TARGET_PROCESSES = MobileSlideShow Foundation tccd
export ARCHS = arm64 arm64e
THEOS_DEVICE_IP = 192.168.102.51

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = HiddenLock14
HiddenLock14_FRAMEWORKS = UIKit LocalAuthentication Foundation
HiddenLock14_FILES = Tweak.x
HiddenLock14_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk