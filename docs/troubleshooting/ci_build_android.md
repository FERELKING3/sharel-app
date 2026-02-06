# CI/Build Android — Troubleshooting

## 🔴 Erreur Commune #1: AGP 8 + Namespace Conflict

### Symptôme
```
error: Manifest merger failed : uses-sdk:minSdkVersion 16 cannot be smaller 
than version 21 declared in library [:permission_handler]
```

### Cause
Android Gradle Plugin 8.0+ requiert namespace explicite et minSdk cohérent.

### Solution
1. **android/app/build.gradle.kts**:
```kotlin
android {
    compileSdk = 34
    
    defaultConfig {
        namespace = "com.sharel.app"
        applicationId = "com.sharel.app"
        minSdk = 21
        targetSdk = 34
    }
}
```

2. **Vérifier android/app/src/main/AndroidManifest.xml**:
   - ❌ Ne PAS avoir `package="..."` (ignoré, namespace prend le pas)
   - ✅ Doit avoir les permissions correctes uniquement

3. **Lancer la build Clean**:
```bash
flutter clean
flutter pub get
flutter build apk --verbose
```

---

## 🔴 Erreur #2: Permission Handler Missing

### Symptôme
```
error: Unresolved reference: android.permission.READ_MEDIA_IMAGES
```

### Cause
`permission_handler` package n'est pas dans pubspec.yaml ou version old.

### Solution
```yaml
dependencies:
  permission_handler: ^11.5.0
```

Puis mettre à jour `android/app/build.gradle.kts`:
```kotlin
dependencies {
    implementation("io.flutter:flutter_embedding_release")
    implementation("com.google.android.material:material:1.12.0")
}
```

---

## 🔴 Erreur #3: Local Network Permission Not Declared

### Symptôme
```
I/ActivityManager: Start proc for activity com.sharel.app: 
unable to bind service com.android.mdnsresponder
```

### Cause
**Missing**: `android.permission.LOCAL_NETWORK` ou `android.permission.CHANGE_NETWORK_STATE`

### Solution
**android/app/src/main/AndroidManifest.xml**:
```xml
<manifest ...>
    <!-- Permissions pour partage fichiers -->
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
    <uses-permission android:name="android.permission.CHANGE_NETWORK_STATE" />
    <uses-permission android:name="android.permission.LOCAL_NETWORK" />
    
    <!-- Lectures fichiers (Android 13+) -->
    <uses-permission android:name="android.permission.READ_MEDIA_IMAGES" />
    <uses-permission android:name="android.permission.READ_MEDIA_VIDEO" />
    <uses-permission android:name="android.permission.READ_MEDIA_AUDIO" />
    
    <!-- Legacy (Android < 13) -->
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
    
    <!-- Camera pour QR scan -->
    <uses-permission android:name="android.permission.CAMERA" />
    
    <application ...>
        ...
    </application>
</manifest>
```

---

## 🔴 Erreur #4: Scoped Storage (Android 11+) — Fichiers Inaccessibles

### Symptôme
```
Exception: Unable to access file: /storage/emulated/0/DCIM/Camera/photo.jpg
FileSystemException: Cannot open file, path = '/storage/...'
```

### Cause
Scoped Storage (Android 11+) restreint accès au-delà de `getExternalFilesDir()`.

### Solution
1. **Pour accès WRITE dans Downloads**:
   ```xml
   <uses-permission android:name="android.permission.MANAGE_EXTERNAL_STORAGE" />
   ```
   (⚠️ Méti Special App Access sur Google Play)

2. **Ou utiliser ApplicationFilesDirectory** (recommandé):
   ```dart
   final appDir = await getApplicationDocumentsDirectory();
   final file = File('${appDir.path}/SHAREL/monFichier.zip');
   ```

3. **Ou utiliser getExternalFilesDir()** (per-app):
   ```dart
   final dirs = await getExternalStorageDirectories(type: StorageDirectory.documents);
   ```

---

## 🔴 Erreur #5: Release Build Unsigned/Unsigned Apk

### Symptôme
```
error: Release build cannot be run on unsigned APK
```

### Solution (Développement — Utiliser Debug)
```bash
flutter build apk --debug
# ou
flutter run -d <device>
```

### Solution (Production — Signer)
1. **Générer key store** (une seule fois):
```bash
keytool -genkey -v -keystore ~/.android/sharel-key.keystore \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias sharel-key
```

2. **Configurer build.gradle.kts**:
```kotlin
signingConfigs {
    release {
        keyAlias = "sharel-key"
        keyPassword = "YOUR_KEY_PASSWORD"
        storeFile = file(System.getProperty("user.home") + "/.android/sharel-key.keystore")
        storePassword = "YOUR_STORE_PASSWORD"
    }
}

buildTypes {
    release {
        signingConfig = signingConfigs.release
    }
}
```

3. **Build signé**:
```bash
flutter build apk --release
```

---

## 🔴 Erreur #6: GitHub Actions Build Failure

### Symptôme
```
error: Unable to locate Java Home
error: Cannot find bundled Java
```

### Solution
**.github/workflows/build.yml**:
```yaml
name: Build APK

on:
  push:
    branches: [ main, develop ]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Java
        uses: actions/setup-java@v4
        with:
          java-version: '17'
          distribution: 'temurin'
      
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.24.0'
      
      - name: Get packages
        run: flutter pub get
      
      - name: Generate l10n
        run: flutter gen-l10n
      
      - name: Build APK
        run: flutter build apk --release
      
      - name: Upload APK
        uses: actions/upload-artifact@v3
        with:
          name: app-release.apk
          path: build/app/outputs/flutter-apk/app-release.apk
```

---

## 💡 Checklist Build

- [ ] `minSdk = 21` dans build.gradle.kts
- [ ] `namespace` défini dans build.gradle.kts
- [ ] Permissions déclarées dans AndroidManifest.xml
- [ ] `permission_handler: ^11.5.0+` dans pubspec.yaml
- [ ] `flutter clean && flutter pub get` exécuté
- [ ] `flutter analyze` pas d'erreurs
- [ ] Device physique/émulateur courant depuis adb
- [ ] APK signé (release build)

---

## 🔗 Ressources

- [Android Developement Docs](https://developer.android.com/)
- [Flutter Android Platform Guide](https://docs.flutter.dev/platform-integration/android)
- [AGP 8.0 Breaking Changes](https://developer.android.com/build/agp-migration)
- [Scoped Storage](https://developer.android.com/about/versions/11/privacy/storage)

---

**Dernière MAJ**: Février 2026  
**Plateforme**: Android 12+ (minSdk 21)
