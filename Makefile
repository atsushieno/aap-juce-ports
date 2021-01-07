
MINIMIZE_INTERMEDIATES=0
NDK_VERSION=21.2.6472646
JUCE_DIR=$(shell pwd)/external/JUCE
PROJUCER_BIN_LINUX=$(JUCE_DIR)/extras/Projucer/Builds/LinuxMakefile/build/Projucer
PROJUCER_BIN_DARWIN=$(JUCE_DIR)/extras/Projucer/Builds/MacOSX/build/Debug/Projucer.app/Contents/MacOS/Projucer
GRADLE_TASK=build

ifeq ($(shell uname), Linux)
	PROJUCER_BIN=$(PROJUCER_BIN_LINUX)
else
ifeq ($(shell uname), Darwin)
	PROJUCER_BIN=$(PROJUCER_BIN_DARWIN)
else
	PROJUCER_BIN=___error___
endif
endif


.PHONY:
all: build

.PHONY:
build: prepare build-aap build-samples

.PHONY:
prepare: build-projucer

.PHONY:
build-projucer: $(PROJUCER_BIN)
	@echo "Projucer target: $(PROJUCER_BIN)"

$(PROJUCER_BIN_LINUX):
	make -C $(JUCE_DIR)/extras/Projucer/Builds/LinuxMakefile
	if [ $(MINIMIZE_INTERMEDIATES) ] ; then \
		rm -rf $(JUCE_DIR)/extras/Projucer/Builds/LinuxMakefile/build/intermediate/ ; \
	fi

$(PROJUCER_BIN_DARWIN):
	xcodebuild -project $(JUCE_DIR)/extras/Projucer/Builds/MacOSX/Projucer.xcodeproj
	if [ $(MINIMIZE_INTERMEDIATES) ] ; then \
		rm -rf $(JUCE_DIR)/extras/Projucer/Builds/MacOSX/build/intermediate/ ; \
	fi

.PHONY:
build-aap:
	cd external/android-audio-plugin-framework && make MINIMIZE_INTERMEDIATES=$(MINIMIZE_INTERMEDIATES)

.PHONY:
build-samples: build-andes build-sarah build-magical8bitplug2 build-obxd

.PHONY:
dist:
	mkdir -p release-builds
	mv  apps/andes/Builds/Android/app/build/outputs/apk/release_/release/app-release_-release.apk   release-builds/andes-release.apk
	mv  apps/SARAH/Builds/Android/app/build/outputs/apk/release_/release/app-release_-release.apk   release-builds/SARAH-release.apk
	mv  apps/Magical8bitPlug2/Builds/Android/app/build/outputs/apk/release_/release/app-release_-release.apk  release-builds/Magical8bitPlug2-release.apk
	mv  apps/OB-Xd/Builds/Android/app/build/outputs/apk/release_/release/app-release_-release.apk  release-builds/OB-Xd-release.apk


.PHONY:
build-andes: create-patched-andes do-build-andes
.PHONY:
do-build-andes:
	echo "PROJUCER is at $(PROJUCER_BIN)"
	NDK_VERSION=$(NDK_VERSION) APPNAME=Andes_1 PROJUCER=$(PROJUCER_BIN) ANDROID_SDK_ROOT=$(ANDROID_SDK_ROOT) GRADLE_TASK=$(GRADLE_TASK) aap-juce/build-sample.sh apps/andes/Andes-1.jucer
.PHONY:
create-patched-andes: apps/andes/.stamp 
apps/andes/.stamp: \
		external/andes/** \
		apps/andes-aap.patch \
		apps/override.Andes-1.jucer \
		aap-juce/sample-project.*
	aap-juce/create-patched-juce-app.sh  Andes-1  external/andes \
		apps/andes  ../andes-aap.patch  0  apps/override.Andes-1.jucer

.PHONY:
build-sarah: create-patched-sarah do-build-sarah
.PHONY:
do-build-sarah:
	echo "PROJUCER is at $(PROJUCER_BIN)"
	NDK_VERSION=$(NDK_VERSION) APPNAME=SARAH PROJUCER=$(PROJUCER_BIN) ANDROID_SDK_ROOT=$(ANDROID_SDK_ROOT) GRADLE_TASK=$(GRADLE_TASK) aap-juce/build-sample.sh apps/SARAH/SARAH.jucer
.PHONY:
create-patched-sarah: apps/SARAH/.stamp 
apps/SARAH/.stamp: \
		external/SARAH/** \
		apps/sarah-aap.patch \
		apps/override.SARAH.jucer \
		aap-juce/sample-project.*
	aap-juce/create-patched-juce-app.sh  SARAH  external/SARAH \
		apps/SARAH  ../sarah-aap.patch  0  apps/override.SARAH.jucer

.PHONY:
build-magical8bitplug2: create-patched-magical8bitplug2 do-build-magical8bitplug2
.PHONY:
do-build-magical8bitplug2:
	echo "PROJUCER is at $(PROJUCER_BIN)"
	NDK_VERSION=$(NDK_VERSION) APPNAME=Magical8bitPlug2 PROJUCER=$(PROJUCER_BIN) ANDROID_SDK_ROOT=$(ANDROID_SDK_ROOT) GRADLE_TASK=$(GRADLE_TASK) aap-juce/build-sample.sh apps/Magical8bitPlug2/Magical8bitPlug2.jucer
.PHONY:
create-patched-magical8bitplug2: apps/Magical8bitPlug2/.stamp 
apps/Magical8bitPlug2/.stamp: \
		external/Magical8bitPlug2/** \
		apps/magical8bitplug2-aap.patch \
		apps/override.Magical8bitPlug2.jucer \
		aap-juce/sample-project.*
	aap-juce/create-patched-juce-app.sh  Magical8bitPlug2  external/Magical8bitPlug2 \
		apps/Magical8bitPlug2  ../magical8bitplug2-aap.patch  1  apps/override.Magical8bitPlug2.jucer

.PHONY:
build-obxd: create-patched-obxd do-build-obxd
.PHONY:
do-build-obxd:
	echo "PROJUCER is at $(PROJUCER_BIN)"
	NDK_VERSION=$(NDK_VERSION) MACAPPNAME=Obxd APPNAME=OB_Xd PROJUCER=$(PROJUCER_BIN) ANDROID_SDK_ROOT=$(ANDROID_SDK_ROOT) GRADLE_TASK=$(GRADLE_TASK) aap-juce/build-sample.sh apps/OB-Xd/OB_Xd.jucer
.PHONY:
create-patched-obxd: apps/OB-Xd/.stamp 
apps/OB-Xd/.stamp: \
		external/OB-Xd/** \
		apps/andes-aap.patch \
		apps/override.OB-Xd.jucer \
		aap-juce/sample-project.*
	aap-juce/create-patched-juce-app.sh  OB_Xd  external/OB-Xd \
		apps/OB-Xd  ../obxd-aap.patch  1  apps/override.OB-Xd.jucer


