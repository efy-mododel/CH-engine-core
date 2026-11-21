#!/usr/bin/env bash
set -euo pipefail

# Build CH-ENGINE core Android APK (debug by default, or pass "release")
BUILD_TYPE="${1:-debug}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ANDROID_APP_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
WEB_APP_DIR="$(cd "${ANDROID_APP_DIR}/../app" && pwd)"

echo "==> [1/4] Installing web IDE dependencies and building web bundle..."
cd "${WEB_APP_DIR}"
if [ ! -d "node_modules" ]; then
  npm install
fi
export NODE_OPTIONS="${NODE_OPTIONS:---max-old-space-size=6144}"
CI=false npm run build

echo "==> [2/4] Installing Android wrapper dependencies..."
cd "${ANDROID_APP_DIR}"
if [ ! -d "node_modules" ]; then
  npm install
fi

echo "==> [3/4] Syncing web assets into Capacitor Android project..."
npx cap sync android

echo "==> [4/4] Compiling Android APK (${BUILD_TYPE})..."
cd "${ANDROID_APP_DIR}/android"
chmod +x ./gradlew

if [ "${BUILD_TYPE}" = "release" ]; then
  ./gradlew assembleRelease
  APK_SRC="${ANDROID_APP_DIR}/android/app/build/outputs/apk/release/app-release-unsigned.apk"
  APK_DST="${ANDROID_APP_DIR}/CH-ENGINE-core-release-unsigned.apk"
else
  ./gradlew assembleDebug
  APK_SRC="${ANDROID_APP_DIR}/android/app/build/outputs/apk/debug/app-debug.apk"
  APK_DST="${ANDROID_APP_DIR}/CH-ENGINE-core-debug.apk"
fi

if [ -f "${APK_SRC}" ]; then
  cp "${APK_SRC}" "${APK_DST}"
  echo "✅ APK built successfully: ${APK_DST}"
else
  echo "❌ Expected APK not found at: ${APK_SRC}" >&2
  exit 1
fi
