# Permissions iOS

**Version:** 1.0  
**Date:** 2026-02-06  
**Scope:** iOS 14+

## Matrice des permissions

| Permission | iOS | Raison | État |
|-----------|-----|--------|------|
| `NSLocalNetworkUsageDescription` | 14+ | Serveur HTTP local | ✅ Requis v1.0 |
| `NSBonjourServiceTypes` | 14+ | mDNS discovery | ⬜ Futur v1.1 |
| `NSPhotosUsageDescription` | 13+ | Photos/Médias | ✅ Runtime |
| `NSContactsUsageDescription` | 13+ | Contacts | ✅ Runtime |
| `NSCameraUsageDescription` | 13+ | QR scan | ✅ Runtime |
| `NSLocationWhenInUseUsageDescription` | 14+ | Wi‑Fi Direct | ⬜ Futur v2.0 |
| `NSBluetoothPeripheralUsageDescription` | 13+ | Bluetooth (futur) | ⬜ Futur v2.0 |

## Implémentation

### Info.plist

```xml
<key>NSLocalNetworkUsageDescription</key>
<string>SHAREL a besoin d'accès au réseau local pour créer une room de partage.</string>

<key>NSBonjourServiceTypes</key>
<array>
  <string>_sharel._tcp</string>
</array>

<key>NSPhotosUsageDescription</key>
<string>SHAREL a besoin d'accès à vos photos pour les partager.</string>

<key>NSContactsUsageDescription</key>
<string>SHAREL a besoin d'accès à vos contacts pour les sélectionner.</string>

<key>NSCameraUsageDescription</key>
<string>SHAREL a besoin d'accès à la caméra pour scanner des codes QR.</string>
```

## Spécificités iOS

### Mode Hotspot

- **Limitation API:** App ne peut pas créer/activer hotspot.
- **Workaround:** Guider user: "Paramètres > Personnel > Hotspot".
- **Détection:** Vérifier `NetworkInterface` pour IPv4.

### Local Network (iOS 14+)

- Prompt affiche device name + cercle privé / public.
- User peut refuser "Local Network" sans affecter app globale.
- Nécessaire pour serveur HTTP inbound.

### Photo Picker (iOS 14+)

- Utiliser `PHPickerViewController` (moderne) au lieu d'Assets.
- Respect privacy: pas d'accès direct aux photos.

### Restrictions Sandbox

- Pas d'accès `/var`, `/lib`, seulement `…/Documents`, `/tmp`.
- Fichiers partagés: utiliser `FileSharing` (iTunes / Files app).

## Comportement permissions

```dart
// Prompt initial
let status = AVCaptureDevice.authorizationStatus(for: .audio)
if status == .notDetermined {
  AVCaptureDevice.requestAccess(for: .audio) { _ in }
}

// Vérifier access
if NEHotspotHelper.isValidating() {
  // Peut créer hotspot ? (limité)
}
```

## UX iOS

### Cas 1: Permission refusée

```
Message: "Accès au réseau local refusé"
Action: 
  - Paramètres > [AppName] > Local Network > ✓
  - Afficher lien direct via Settings app
```

### Cas 2: Hotspot non disponible

```
Message: "Activez Hotspot pour partager en hors-WiFi"
Action: 
  - Rediriger vers Paramètres > Personnel > Hotspot
  - Note: Automatisation limitée
```

### Cas 3: Photo picker

```
- Utiliser PHPickerViewController (permissif).
- Système gère accès granulaire.
```

## Checklist iOS

- ✅ `NSLocalNetworkUsageDescription` dans Info.plist.
- ✅ Demander permission au lancement (via `NetworkInterface` first access).
- ✅ Afficher prompt mDNS (iOS 14+).
- ✅ Gérer refus avec avertissement clair.
- ✅ Test sur iOS 14, 15, 16, 17.

## Futur (v2.0)

- mDNS (Bonjour) pour discovery.
- Bluetooth (requiert `NSBluetoothPeripheralUsageDescription`).
- Gestion hotspot améliorée.
