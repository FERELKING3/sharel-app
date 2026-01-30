# Copilot Instructions - SHAREL Flutter App

## 📱 Project Overview
**SHAREL une app Flutter de partage de fichiers cross-platform (Android, iOS, Web, macOS, Linux, Windows). L'UI s'inspire de ShareIt avec trois modules principaux : **Envoyer**, **Recevoir**, **Fichiers**. Langue par défaut : français.

## 🏗️ Architecture

### Structure Modulaire
```
lib/
├── main.dart                 # App shell, thème, i18n, navigation
├── core/
│   ├── theme.dart           # Thème Material 3, couleurs, typographie
│   ├── constants.dart       # URLs, timeouts, configurations
│   └── extensions.dart      # Extensions utiles (context, etc.)
├── models/                  # Modèles de données
├── screens/
│   ├── home/                # Accueil (3 boutons principaux)
│   ├── sender/              # Envoyer des fichiers
│   ├── receiver/            # Recevoir des fichiers
│   ├── files/               # Gestionnaire de fichiers
│   └── discovery/           # Découvrir d'autres devices
├── widgets/                 # Composants réutilisables
├── providers/               # État (Provider/Riverpod)
└── l10n/                    # Fichiers de traduction (ARB)
```

### État & Dépendances
- **State Management** : Provider (simple, performant)
- **Localisation** : flutter_localizations + intl (fichiers `.arb` dans `lib/l10n/`)
- **Pas de dépendances inutiles** : Éviter des packages volumineux

## 📋 Key Patterns & Conventions

### 1. Thème & Design
- **Couleurs** : Bleu primaire (#0066FF), vert accent (#00DD88), gris neutre (#F5F5F5)
- **Layout Adaptatif** :
  - Téléphone : Bottom navigation (onglets)
  - Tablet/Desktop : Navigation rail (gauche) + contenu centré
- **Composants** : Material 3 (Material(), Card(), ElevatedButton())
- **Référence** : La capture d'écran montre hierarchie visuelle avec gros boutons arrondis

### 2. Localisation (i18n)
- Fichier de base : `lib/l10n/app_fr.arb` (français)
- Gencode automatique via `flutter gen-l10n`
- Accès en Dart : `AppLocalizations.of(context)!.labelKey`
- Les clés commencent par `label` (labels), `button` (boutons), `message` (messages)

### 3. Fichiers Volumineux = Danger ❌
**Interdiction stricte** : Fichiers > 200 lignes doivent être scindés
- Un screen = une classe `StatelessWidget` ou `StatefulWidget` uniquement
- Logique métier → `providers/`
- Widgets réutilisables → `widgets/`
- Modèles → `models/`

### 4. Modularité & Import
```dart
// ❌ Mauvais : import absolu sans logique claire
import 'package:sharel_app/screens/home/home_page.dart';

// ✅ Bon : imports organisés, export depuis barrel files
export 'home_page.dart';
export 'widgets/device_card.dart';
```

### 5. Commentaires
- **Interdiction** : Commentaires de 4+ lignes, documenter le code avant d'écrire
- **Autorisé** : 1-2 lignes max, justifier une logique complexe uniquement
- Format : `// TODO: implémenter logique de transfert`

## 🔧 Commandes Essentielles

```bash
# Génération du code i18n
flutter gen-l10n

# Dev Web (local)
flutter run -d web-server --web-hostname=0.0.0.0 --web-port=8080

# Build
flutter build apk          # Android
flutter build ios          # iOS
flutter build web          # Web
flutter build macos        # macOS

# Analyse de qualité
flutter analyze
```

## 📦 Dépendances Requises

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  flutter_localizations:
    sdk: flutter
  intl: ^0.19.0
  provider: ^6.1.0
```

## 🎨 UI Guidelines

### Home Screen
- Trois grands boutons circulaires : Envoyer, Recevoir, Fichiers
- Cards avec icônes Material (Icons.send, Icons.cloud_download, Icons.folder)
- Spacing cohérent (16-24 dp padding)

### Responsive Layout
- **< 600 dp** : Single column, bottom nav
- **600-1200 dp** : 2-column grid, navigation rail
- **> 1200 dp** : 3-column grid, desktop layout

### Données Mockées
```dart
final mockDevices = [
  {'name': 'Mon iPhone', 'type': 'iOS'},
  {'name': 'PC Bureau', 'type': 'Windows'},
];
```

## 🚀 Development Workflow

1. **Feature** : Créer branche `feature/xxx`
2. **Code** : Respecter la modularité (< 200 lignes/fichier)
3. **Test** : `flutter analyze`, vérifier sur web/mobile
4. **i18n** : Ajouter clés `.arb`, générer avec `flutter gen-l10n`
5. **PR** : Inclure TODOs pour travail futur (plugins, sockets, etc.)

## ⚠️ Pièges Communs

- **Ne pas** importer récursivement (barrel files mal gérées)
- **Ne pas** avoir du code métier dans les Widgets
- **Ne pas** utiliser des dépendances tierces sans justification
- **Ne pas** oublier de configurer i18n avant de hardcoder du texte

## 📝 Configuration Android/iOS

### Android
- `applicationId` : `com.sharel.app`
- `minSdk` : 21, `targetSdk` : 34

### iOS
- `CFBundleDisplayName` : "SHAREL"
- Localisation française par défaut

---

**Principes Clés** : Modularité, performance, maintenabilité. Code lisible > code malin. TODOs pour futures implémentations.
