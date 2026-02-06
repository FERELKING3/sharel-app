# Stockage des fichiers reçus

**Version:** 1.0  
**Date:** 2026-02-06

## Android

### Chemins de sauvegarde

- **Android < 11:** `getExternalFilesDir("Sharel")` → `/Android/data/com.sharel.app/files/Sharel/`
- **Android 11-13:** Même chemin (Scoped Storage permis).
- **Android 14+:** Scoped Storage strict → dossier d'app uniquement OU media external (Photos, Download).

### Visibilité utilisateur

Par défaut, sauver dans `getDownloadsDirectory()` (dossier Downloads visible en galerie).

### Collisions de noms

Si `file.pdf` existe :
1. Chercher `file (1).pdf`, `file (2).pdf`, ...
2. Renommer localement : garder trace originale.

### Atomic write

```dart
final tmpFile = File('${saveDir}/file.pdf.part');
await tmpFile.writeAsBytes(data);
await tmpFile.rename('${saveDir}/file.pdf'); // rename atomique
```

## iOS

### Chemins

- **Documents:** `getApplicationDocumentsDirectory()` — visible à l'user via Files app.
- **Cache:** `getTemporaryDirectory()` — peut être purgé par OS.

Recommandation: Documents pour persistance, avec option UI.

### Restrictions

- Pas d'accès direct au système de fichiers (pas de `/var/...`).
- Utiliser `file_picker` pour sélectionner dossier.

## Permissions nécessaires

- Android: `android.permission.READ_EXTERNAL_STORAGE` (accès lecture), `MANAGE_EXTERNAL_STORAGE` (Android 11+).
- iOS: `NSHomeDirectoryUsageDescription` (prompt pour accès Documents).

## Limitation actuelle

- ✅ Chemin unique (`saveDir`).
- ⬜ Récursif (dossiers).
- ⬜ Symlinks.
- ⬜ Permissions fichier (uid/gid).

## Futur (v1.1)

- Créer dossier par transfert (`Sharel/<transferId>/`).
- Option "Destination" avec file picker.
- Intégration MediaStore (Android).
