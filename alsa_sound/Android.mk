# hardware/libaudio-alsa/Android.mk
#
# Copyright 2008 Wind River Systems
#

ifeq ($(strip $(BOARD_USES_ALSA_AUDIO)),true)

LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_ARM_MODE := arm
LOCAL_CFLAGS := $(common_flags)
LOCAL_CFLAGS += -D_POSIX_SOURCE
LOCAL_CFLAGS += -DQCOM_ACDB_ENABLED
LOCAL_CFLAGS += -DQCOM_ANC_HEADSET_ENABLED
LOCAL_CFLAGS += -DQCOM_AUDIO_FORMAT_ENABLED
LOCAL_CFLAGS += -DQCOM_CSDCLIENT_ENABLED
#LOCAL_CFLAGS += -DQCOM_FM_ENABLED
LOCAL_CFLAGS += -DQCOM_PROXY_DEVICE_ENABLED
LOCAL_CFLAGS += -DQCOM_OUTPUT_FLAGS_ENABLED
LOCAL_CFLAGS += -DQCOM_TUNNEL_LPA_ENABLED
#LOCAL_CFLAGS += -DQCOM_SSR_ENABLED
LOCAL_CFLAGS += -DQCOM_USBAUDIO_ENABLED

ifeq ($(call is-board-platform,msm8974),true)
  LOCAL_CFLAGS += -DTARGET_8974
endif

ifneq ($(ALSA_DEFAULT_SAMPLE_RATE),)
    LOCAL_CFLAGS += -DALSA_DEFAULT_SAMPLE_RATE=$(ALSA_DEFAULT_SAMPLE_RATE)
endif

#Do not use Dual MIC scenario in call feature
#Dual MIC solution(Fluence) feature in Built-in MIC used scenarioes.
# 1. Handset
# 2. 3-Pole Headphones
ifeq ($(strip $(BOARD_USES_FLUENCE_INCALL)),true)
LOCAL_CFLAGS += -DUSES_FLUENCE_INCALL
endif

ifeq ($(strip $(BOARD_USES_FLUENCE_FOR_VOIP)),true)
LOCAL_CFLAGS += -DUSES_FLUENCE_FOR_VOIP
endif

#Do not use separate audio Input path feature
#Separate audio input path can be set using input source of audio parameter
# 1. Voice Recognition
# 2. Camcording
# 3. etc.
ifeq ($(strip $(BOARD_USES_SEPERATED_AUDIO_INPUT)),true)
LOCAL_CFLAGS += -DSEPERATED_AUDIO_INPUT
endif

ifeq ($(strip $(BOARD_USES_SEPERATED_VOICE_SPEAKER)),true)
LOCAL_CFLAGS += -DSEPERATED_VOICE_SPEAKER
endif

ifeq ($(strip $(BOARD_USES_SEPERATED_HEADSET_MIC)),true)
LOCAL_CFLAGS += -DSEPERATED_HEADSET_MIC
endif

ifeq ($(strip $(BOARD_USES_SEPERATED_VOIP)),true)
LOCAL_CFLAGS += -DSEPERATED_VOIP
endif

ifeq ($(BOARD_AUDIO_EXPECTS_MIN_BUFFERSIZE),true)
    LOCAL_CFLAGS += -DSET_MIN_PERIOD_BYTES
endif

ifeq ($(BOARD_AUDIO_CAF_LEGACY_INPUT_BUFFERSIZE),true)
    LOCAL_CFLAGS += -DCAF_LEGACY_INPUT_BUFFER_SIZE
endif

ifeq ($(BOARD_HAVE_AUDIENCE_A2220),true)
  LOCAL_CFLAGS += -DUSE_A2220
endif

ifeq ($(BOARD_HAVE_DOCK_USBAUDIO),true)
  LOCAL_CFLAGS += -DDOCK_USBAUDIO_ENABLED
endif

ifeq ($(BOARD_HAVE_NEW_QCOM_CSDCLIENT),true)
  LOCAL_CFLAGS += -DNEW_CSDCLIENT
endif

ifeq ($(BOARD_HAVE_AUDIENCE_ES325_2MIC),true)
  LOCAL_CFLAGS += -DUSE_ES325_2MIC
endif

ifeq ($(BOARD_HAVE_SAMSUNG_CSDCLIENT),true)
  LOCAL_CFLAGS += -DSAMSUNG_CSDCLIENT
endif

ifeq ($(BOARD_HAVE_HTC_CSDCLIENT),true)
  LOCAL_CFLAGS += -DHTC_CSDCLIENT
endif

LOCAL_SRC_FILES := \
  AudioHardwareALSA.cpp         \
  AudioStreamOutALSA.cpp        \
  AudioStreamInALSA.cpp         \
  ALSAStreamOps.cpp             \
  audio_hw_hal.cpp              \
  AudioUsbALSA.cpp              \
  AudioUtil.cpp                 \
  AudioSessionOut.cpp           \
  ALSADevice.cpp

LOCAL_STATIC_LIBRARIES := \
    libmedia_helper \
    libaudiohw_legacy \
    libaudiopolicy_legacy \

LOCAL_SHARED_LIBRARIES := \
    libcutils \
    libutils \
    libmedia \
    libhardware \
    libc        \
    libpower    \
    libalsa-intf \
    libaudioutils

#    libsurround_proc

ifeq ($(TARGET_SIMULATOR),true)
 LOCAL_LDLIBS += -ldl
else
 LOCAL_SHARED_LIBRARIES += libdl
endif

ifneq ($(BOARD_AUDIO_AMPLIFIER),)
LOCAL_CFLAGS += -DUSES_AUDIO_AMPLIFIER
LOCAL_SHARED_LIBRARIES += libaudioamp
LOCAL_C_INCLUDES += $(BOARD_AUDIO_AMPLIFIER)
endif

LOCAL_C_INCLUDES += $(TARGET_OUT_HEADERS)/mm-audio/audio-alsa
LOCAL_C_INCLUDES += $(TARGET_OUT_HEADERS)/mm-audio/libalsa-intf
LOCAL_C_INCLUDES += $(TARGET_OUT_HEADERS)/mm-audio/surround_sound/
LOCAL_C_INCLUDES += hardware/libhardware/include
LOCAL_C_INCLUDES += hardware/libhardware_legacy/include
LOCAL_C_INCLUDES += frameworks/base/include
LOCAL_C_INCLUDES += system/core/include
LOCAL_C_INCLUDES += system/media/audio_utils/include

LOCAL_C_INCLUDES += $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/usr/include
LOCAL_ADDITIONAL_DEPENDENCIES := $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/usr

ifeq ($(call is-board-platform,msm8974),true)
  LOCAL_MODULE := audio.primary.msm8974
endif

ifeq ($(call is-board-platform,msm8960),true)
  LOCAL_MODULE := audio.primary.msm8960
endif

ifeq ($(call is-board-platform,msm8610),true)
  LOCAL_MODULE := audio.primary.msm8610
endif

LOCAL_MODULE_PATH := $(TARGET_OUT_SHARED_LIBRARIES)/hw
LOCAL_MODULE_TAGS := optional

include $(BUILD_SHARED_LIBRARY)

include $(CLEAR_VARS)

LOCAL_CFLAGS := -D_POSIX_SOURCE
LOCAL_CFLAGS += -DQCOM_ACDB_ENABLED
LOCAL_CFLAGS += -DQCOM_ANC_HEADSET_ENABLED
LOCAL_CFLAGS += -DQCOM_AUDIO_FORMAT_ENABLED
LOCAL_CFLAGS += -DQCOM_CSDCLIENT_ENABLED
#LOCAL_CFLAGS += -DQCOM_FM_ENABLED
LOCAL_CFLAGS += -DQCOM_PROXY_DEVICE_ENABLED
#LOCAL_CFLAGS += -DQCOM_SSR_ENABLED
LOCAL_CFLAGS += -DQCOM_USBAUDIO_ENABLED

LOCAL_SRC_FILES := \
    audio_policy_hal.cpp \
    AudioPolicyManagerALSA.cpp


ifeq ($(call is-board-platform,msm8974),true)
  LOCAL_MODULE := audio_policy.msm8974
endif

ifeq ($(call is-board-platform,msm8960),true)
  LOCAL_MODULE := audio_policy.msm8960
endif

ifeq ($(call is-board-platform,msm8610),true)
  LOCAL_MODULE := audio_policy.msm8610
endif

LOCAL_MODULE_PATH := $(TARGET_OUT_SHARED_LIBRARIES)/hw
LOCAL_MODULE_TAGS := optional

LOCAL_STATIC_LIBRARIES := \
    libmedia_helper \
    libaudiopolicy_legacy

LOCAL_SHARED_LIBRARIES := \
    libcutils \
    libutils \

LOCAL_C_INCLUDES += hardware/libhardware_legacy/audio

include $(BUILD_SHARED_LIBRARY)

endif
