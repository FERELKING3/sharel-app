import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../responsive/responsive_config.dart';

/// Settings state class
class SettingsState {
  final DockPosition dockPosition;
  final int navStyleIndex;
  final bool isDarkMode;
  final String languageCode;
  final int uiDensity; // 0 = compact, 1 = normal, 2 = spacious
  final bool hasSeenOnboarding;

  const SettingsState({
    this.dockPosition = DockPosition.bottom,
    this.navStyleIndex = 8, // STYLE 8 for persistent_bottom_nav_bar_v2
    this.isDarkMode = false,
    this.languageCode = 'fr',
    this.uiDensity = 1,
    this.hasSeenOnboarding = false,
  });

  SettingsState copyWith({
    DockPosition? dockPosition,
    int? navStyleIndex,
    bool? isDarkMode,
    String? languageCode,
    int? uiDensity,
    bool? hasSeenOnboarding,
  }) {
    return SettingsState(
      dockPosition: dockPosition ?? this.dockPosition,
      navStyleIndex: navStyleIndex ?? this.navStyleIndex,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      languageCode: languageCode ?? this.languageCode,
      uiDensity: uiDensity ?? this.uiDensity,
      hasSeenOnboarding: hasSeenOnboarding ?? this.hasSeenOnboarding,
    );
  }
}

/// Settings notifier
class SettingsNotifier extends StateNotifier<SettingsState> {
  late SharedPreferences _prefs;

  SettingsNotifier() : super(const SettingsState()) {
    _initialize();
  }

  Future<void> _initialize() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final dockPosStr =
          _prefs.getString('dockPosition') ?? DockPosition.bottom.toString();
      final dockPos = DockPosition.values.firstWhere(
        (e) => e.toString() == dockPosStr,
        orElse: () => DockPosition.bottom,
      );

      final navStyle = _prefs.getInt('navStyleIndex') ?? 8;
      final isDark = _prefs.getBool('isDarkMode') ?? false;
      final lang = _prefs.getString('languageCode') ?? 'fr';
      final density = _prefs.getInt('uiDensity') ?? 1;
      final onboarding = _prefs.getBool('hasSeenOnboarding') ?? false;

      state = SettingsState(
        dockPosition: dockPos,
        navStyleIndex: navStyle,
        isDarkMode: isDark,
        languageCode: lang,
        uiDensity: density,
        hasSeenOnboarding: onboarding,
      );
    } catch (e) {
      debugPrint('[SettingsNotifier] Error loading settings: $e');
    }
  }

  Future<void> setDockPosition(DockPosition position) async {
    state = state.copyWith(dockPosition: position);
    await _prefs.setString('dockPosition', position.toString());
  }

  Future<void> setNavStyle(int index) async {
    state = state.copyWith(navStyleIndex: index);
    await _prefs.setInt('navStyleIndex', index);
  }

  Future<void> setDarkMode(bool isDark) async {
    state = state.copyWith(isDarkMode: isDark);
    await _prefs.setBool('isDarkMode', isDark);
  }

  Future<void> setLanguage(String languageCode) async {
    state = state.copyWith(languageCode: languageCode);
    await _prefs.setString('languageCode', languageCode);
  }

  Future<void> setUIDensity(int density) async {
    state = state.copyWith(uiDensity: density);
    await _prefs.setInt('uiDensity', density);
  }

  Future<void> setOnboardingCompleted() async {
    state = state.copyWith(hasSeenOnboarding: true);
    await _prefs.setBool('hasSeenOnboarding', true);
  }
}

/// Settings provider
final settingsProvider =
    StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  return SettingsNotifier();
});

/// Individual setting providers for easier access
final dockPositionProvider = Provider<DockPosition>((ref) {
  return ref.watch(settingsProvider).dockPosition;
});

final navStyleIndexProvider = Provider<int>((ref) {
  return ref.watch(settingsProvider).navStyleIndex;
});

final isDarkModeProvider = Provider<bool>((ref) {
  return ref.watch(settingsProvider).isDarkMode;
});

final languageCodeProvider = Provider<String>((ref) {
  return ref.watch(settingsProvider).languageCode;
});

final uiDensityProvider = Provider<int>((ref) {
  return ref.watch(settingsProvider).uiDensity;
});

final hasSeenOnboardingProvider = Provider<bool>((ref) {
  return ref.watch(settingsProvider).hasSeenOnboarding;
});
