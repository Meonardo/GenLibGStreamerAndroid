LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

# APP_ALLOW_MISSING_DEPS := true
LOCAL_MODULE := gstreamer_for_android
LOCAL_SHARED_LIBRARIES := gstreamer_android
LOCAL_LDLIBS := -llog

include $(BUILD_SHARED_LIBRARY)

ifndef GSTREAMER_ROOT_ANDROID
$(error GSTREAMER_ROOT_ANDROID is not defined!)
endif

ifeq ($(TARGET_ARCH_ABI),armeabi-v7a)
GSTREAMER_ROOT        := $(GSTREAMER_ROOT_ANDROID)/armeabi-v7a
else ifeq ($(TARGET_ARCH_ABI),arm64-v8a)
GSTREAMER_ROOT        := $(GSTREAMER_ROOT_ANDROID)/arm64-v8a
else ifeq ($(TARGET_ARCH_ABI),x86)
GSTREAMER_ROOT        := $(GSTREAMER_ROOT_ANDROID)/x86
else ifeq ($(TARGET_ARCH_ABI),x86_64)
GSTREAMER_ROOT        := $(GSTREAMER_ROOT_ANDROID)/x86_64
else
$(error Target arch ABI not supported: $(TARGET_ARCH_ABI))
endif

GSTREAMER_NDK_BUILD_PATH  := $(GSTREAMER_ROOT)/share/gst-android/ndk-build
include $(GSTREAMER_NDK_BUILD_PATH)/plugins.mk
GSTREAMER_PLUGINS         := $(GSTREAMER_PLUGINS_CORE) $(GSTREAMER_PLUGINS_CODECS) $(GSTREAMER_PLUGINS_ENCODING) $(GSTREAMER_PLUGINS_NET) $(GSTREAMER_PLUGINS_PLAYBACK) $(GSTREAMER_PLUGINS_SYS) $(GSTREAMER_PLUGINS_EFFECTS) $(GSTREAMER_PLUGINS_VIS) $(GSTREAMER_PLUGINS_CAPTURE) $(GSTREAMER_PLUGINS_CODECS_RESTRICTED) $(GSTREAMER_PLUGINS_NET_RESTRICTED) $(GSTREAMER_PLUGINS_GES)
GSTREAMER_EXTRA_DEPS      := glib-2.0 gobject-2.0 gstreamer-base-1.0 gstreamer-video-1.0 gstreamer-audio-1.0 gstreamer-player-1.0 gstreamer-sdp-1.0 gstreamer-webrtc-1.0 gstreamer-photography-1.0 gstreamer-allocators-1.0 gstreamer-app-1.0 gstreamer-rtsp-server-1.0 gstreamer-rtsp-1.0 gstreamer-rtp-1.0 librga

include $(GSTREAMER_NDK_BUILD_PATH)/gstreamer-1.0.mk
