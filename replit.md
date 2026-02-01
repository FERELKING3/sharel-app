# SHAREL App

## Overview

SHAREL is a cross-platform file sharing Flutter application targeting Android, iOS, Web, macOS, Linux, and Windows. The app is inspired by ShareIt with three main modules: **Send**, **Receive**, and **Files**. The home screen features large action buttons and a notification center accessible via an icon in the top-right corner.

## User Preferences

Preferred communication style: Simple, everyday language.

## System Architecture

### Frontend Framework
- **Flutter** with Dart as the primary development framework
- **Material 3** design system with custom theming
- Cross-platform support via Flutter's native platform runners (iOS, Android, Web, Linux, Windows, macOS)

### Project Structure
```
lib/
├── main.dart                 # App shell, theme, i18n, navigation
├── core/
│   ├── theme.dart           # Material 3 theme, colors, typography
│   ├── constants.dart       # URLs, timeouts, configurations
│   └── extensions.dart      # Utility extensions
├── models/                  # Data models
├── screens/
│   ├── home/                # Home (3 main buttons)
│   ├── sender/              # Send files
│   ├── receiver/            # Receive files
│   ├── files/               # File manager
│   └── discovery/           # Device discovery
├── widgets/                 # Reusable components
├── providers/               # State management
└── l10n/                    # Localization (ARB files)
```

### State Management
- **Provider/Riverpod** for application state
- Simple, performant state management approach

### Localization
- **flutter_localizations** + **intl** package
- ARB files in `lib/l10n/` directory
- French as base language (`app_fr.arb`)
- Auto-generated via `flutter gen-l10n`

### Design System
- **Primary color**: Blue (#0066FF)
- **Accent color**: Green (#00DD88)
- **Neutral color**: Gray (#F5F5F5)
- **Adaptive layouts**: 
  - Phone: Bottom navigation tabs
  - Tablet/Desktop: Navigation rail on left with centered content

### Code Quality Rules
- **File size limit**: Maximum 200 lines per file
- Files exceeding this limit must be split into smaller modules

## External Dependencies

### Core Packages
- **dio**: HTTP client for network requests
- **go_router**: Declarative routing
- **flutter_riverpod**: State management
- **freezed** + **freezed_annotation**: Immutable data classes with code generation
- **json_serializable**: JSON serialization

### Media & Files
- **file_picker**: File selection
- **photo_manager**: Photo/video access
- **on_audio_query**: Audio file queries
- **device_apps**: Installed apps access (Android)
- **flutter_contacts**: Contacts access

### UI
- **flex_color_scheme**: Theming utilities
- **flutter_animate**: Animations
- **font_awesome_flutter**: Icons
- **cupertino_icons**: iOS-style icons
- **shimmer**: Loading placeholders

### Permissions
- **permission_handler**: Runtime permission management

### Build Tools
- **build_runner**: Code generation runner