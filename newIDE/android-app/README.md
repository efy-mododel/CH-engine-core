# CH-ENGINE core — Android APK

Android wrapper (Capacitor) for **CH-ENGINE core**.

- **App Name:** `CH-ENGINE core`
- **Application ID:** `com.chengine.core`
- **Min SDK:** 23 (Android 6.0)
- **Target / Compile SDK:** 35

## Option 1: Build APK automatically on GitHub Actions

1. Push your branch to GitHub.
2. Open **Actions → Build Android APK (CH-ENGINE core)** in your repository.
3. Run the workflow (or open the run triggered by your push).
4. Download the **`CH-ENGINE-core-apk`** artifact containing `CH-ENGINE-core-debug.apk`.

## Option 2: Build APK locally

### Prerequisites

- Node.js 22+
- JDK 21 (`JAVA_HOME` configured)
- Android SDK (API 35, `ANDROID_HOME` / `ANDROID_SDK_ROOT` configured)

### One-command build

```bash
cd newIDE/android-app
./scripts/build-apk.sh          # builds CH-ENGINE-core-debug.apk
./scripts/build-apk.sh release  # builds CH-ENGINE-core-release-unsigned.apk
```

### Step-by-step build

```bash
# 1. Build the CH-ENGINE core web editor
cd newIDE/app
npm install
NODE_OPTIONS="--max-old-space-size=6144" CI=false npm run build

# 2. Sync assets to Android project
cd ../android-app
npm install
npx cap sync android

# 3. Compile APK with Gradle
cd android
./gradlew assembleDebug
```

The resulting APK will be at:
`newIDE/android-app/android/app/build/outputs/apk/debug/app-debug.apk`
