# Permissions Android

**Version:** 1.0  
**Date:** 2026-02-06  
**Scope:** Android 11-14+

## Matrice des permissions

| Permission | Android | Raison | État |
|-----------|---------|--------|------|
| `INTERNET` | 11+ | Réseau HTTP | ✅ Déclaré |
| `READ_EXTERNAL_STORAGE` | <11 | Lire fichiers | ✅ Runtime |
| `READ_MEDIA_IMAGES` | 13+ | Lire photos | ✅ Runtime |
| `READ_MEDIA_VIDEO` | 13+ | Lire vidéos | ✅ Runtime |
| `READ_MEDIA_AUDIO` | 13+ | Lire musique | ✅ Runtime |
| `MANAGE_EXTERNAL_STORAGE` | 11+ | Accès complet | ⬜ Optionnel v1.1 |
| `ACCESS_NETWORK_STATE` | 11+ | Vérifier réseau | ✅ Runtime |
| `CHANGE_NETWORK_STATE` | 11+ | Wi-Fi/Hotspot | ⬜ Futur |
| `ACCESS_COARSE_LOCATION` | 11+ | Localiser réseau | ⬜ Optionnel |
| `BLUETOOTH_SCAN` | 12+ | Scanner Bluetooth | ⬜ Futur (v2.0) |
| `BLUETOOTH_CONNECT` | 12+ | Connecter BT | ⬜ Futur (v2.0) |
| `NEARBY_WIFI_DEVICES` | 13+ | Wi-Fi Direct | ⬜ Futur (v2.0) |

## Implémentation

### Manifeste (AndroidManifest.xml)

```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />

<!-- Android 13+ (targetApi 33) -->
<uses-permission android:name="android.permission.READ_MEDIA_IMAGES" />
<uses-permission android:name="android.permission.READ_MEDIA_VIDEO" />
<uses-permission android:name="android.permission.READ_MEDIA_AUDIO" />
```

### Runtime (Permission Handler)

```dart
// App launch
PermissionService.requestStoragePermission();

// Preparation screen
Map<String, PermissionStatus> perms = 
  await PermissionService.getRequiredPermissions();
  
// Display UI avec status
if (perms['Photos']?.isDenied ?? false) {
  // Prompt user
  await Permission.photos.request();
}
```

## Android 11 (API 30)

- Scoped Storage obligatoire.
- Dossier app: `/Android/data/<package>/files/`.
- Dossier public (Documents, Downloads): via MediaStore.
- `MANAGE_EXTERNAL_STORAGE` pour accès complet (déprécié en 12+).

## Android 12 (API 31)

- Permissions Bluetooth granulaires.
- Wi-Fi Direct via `NEARBY_WIFI_DEVICES`.
- Hotspot: restricté.

## Android 13 (API 33)

- `READ_MEDIA_*` remplace `READ_EXTERNAL_STORAGE`.
- Granularité par type (photos/vidéos/musique).
- Pas d'accès complet sans `MANAGE_EXTERNAL_STORAGE`.

## Android 14 (API 34)

- Partial Media Permissions (par-fichier).
- Per-app Hibernation.
- Bluetooth: L2CAP / CoD filtrage.

## UX Permission refusée

```
Cas 1: "Don't Ask Again"
- Afficher: "Aller à Paramètres > Permissions > Photos > ✓"
- Bouton: "Ouvrir Paramètres"

Cas 2: Première fois refusée
- Proposer: "Nous avons besoin d'accès pour sélectionner des fichiers"
- Bouton: "Autoriser maintenant"

Cas 3: Scoped Storage non applicable
- Utiliser FILE_PICKER au lieu d'accès direct
```

## Checklist déploiement

- ✅ targetSdk = 34 (Android 14).
- ✅ Permissions déclarées.
- ✅ Runtime requests OK.
- ✅ Gestion refus OK.
- ✅ Test sur Android 11, 12, 13, 14.
