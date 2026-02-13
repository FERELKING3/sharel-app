import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Navigation state provider - tracks active tab index
final navigationIndexProvider = StateProvider<int>((ref) {
  return 0; // Home is default
});

/// Provider to get current route path
final currentRouteProvider = Provider<String>((ref) {
  return '/';
});
