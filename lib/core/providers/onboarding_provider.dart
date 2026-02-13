import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Onboarding state provider
final hasSeenOnboardingProvider = FutureProvider<bool>((ref) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('hasSeenOnboarding') ?? false;
  } catch (e) {
    debugPrint('[Onboarding Provider] Error: $e');
    return false;
  }
});

/// Provider to mark onboarding as completed
final onboardingCompleteProvider =
    FutureProvider.family<void, void>((ref, _) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenOnboarding', true);
    ref.invalidate(hasSeenOnboardingProvider);
  } catch (e) {
    debugPrint('[Onboarding Complete] Error: $e');
  }
});
