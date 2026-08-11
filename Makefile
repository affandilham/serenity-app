# Serenity Android build shortcuts
#
# Examples:
#   make apk-arm64      # arm64-v8a only
#   make apk-all        # separate APKs for all supported Android ABIs

FLUTTER ?= flutter
OUTPUT_DIR := build/app/outputs/flutter-apk

# Prefer an installed Java 17.  The Homebrew fallback keeps this working on
# machines where OpenJDK is installed but not linked as the system Java.
JAVA_HOME ?= $(shell /usr/libexec/java_home -v 17 2>/dev/null)
ifeq ($(strip $(JAVA_HOME)),)
JAVA_HOME := $(shell if command -v brew >/dev/null 2>&1; then brew --prefix openjdk@17 2>/dev/null | sed 's|$$|/libexec/openjdk.jdk/Contents/Home|'; fi)
endif
export JAVA_HOME
export PATH := $(JAVA_HOME)/bin:$(PATH)

.PHONY: help check-java clean apk apk-arm64 apk-armv7 apk-x86_64 apk-all

help:
	@echo "Serenity APK build targets"
	@echo "  make apk          Build one universal release APK"
	@echo "  make apk-arm64    Build an arm64-v8a-only release APK"
	@echo "  make apk-armv7    Build an armeabi-v7a-only release APK"
	@echo "  make apk-x86_64   Build an x86_64-only release APK"
	@echo "  make apk-all      Build one release APK per supported ABI"
	@echo "  make clean        Remove Flutter build artifacts"

check-java:
	@test -n "$(JAVA_HOME)" && test -x "$(JAVA_HOME)/bin/java" || (echo "Java 17 is required. Install it or set JAVA_HOME."; exit 1)

clean:
	$(FLUTTER) clean

apk: check-java
	$(FLUTTER) build apk --release
	mv "$(OUTPUT_DIR)/app-release.apk" "$(OUTPUT_DIR)/serenity-universal-release.apk"

apk-arm64: check-java
	$(FLUTTER) build apk --release --target-platform android-arm64
	mv "$(OUTPUT_DIR)/app-release.apk" "$(OUTPUT_DIR)/serenity-arm64-v8a-release.apk"

apk-armv7: check-java
	$(FLUTTER) build apk --release --target-platform android-arm
	mv "$(OUTPUT_DIR)/app-release.apk" "$(OUTPUT_DIR)/serenity-armeabi-v7a-release.apk"

apk-x86_64: check-java
	$(FLUTTER) build apk --release --target-platform android-x64
	mv "$(OUTPUT_DIR)/app-release.apk" "$(OUTPUT_DIR)/serenity-x86_64-release.apk"

apk-all: check-java
	$(FLUTTER) build apk --release --split-per-abi --target-platform android-arm,android-arm64,android-x64
	mv "$(OUTPUT_DIR)/app-armeabi-v7a-release.apk" "$(OUTPUT_DIR)/serenity-armeabi-v7a-release.apk"
	mv "$(OUTPUT_DIR)/app-arm64-v8a-release.apk" "$(OUTPUT_DIR)/serenity-arm64-v8a-release.apk"
	mv "$(OUTPUT_DIR)/app-x86_64-release.apk" "$(OUTPUT_DIR)/serenity-x86_64-release.apk"
