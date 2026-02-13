import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Auth state class
class AuthState {
  final bool isLoggedIn;
  final String? userEmail;
  final String? userName;
  final String? authToken;

  const AuthState({
    this.isLoggedIn = false,
    this.userEmail,
    this.userName,
    this.authToken,
  });

  AuthState copyWith({
    bool? isLoggedIn,
    String? userEmail,
    String? userName,
    String? authToken,
  }) {
    return AuthState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      userEmail: userEmail ?? this.userEmail,
      userName: userName ?? this.userName,
      authToken: authToken ?? this.authToken,
    );
  }
}

/// Auth notifier
class AuthNotifier extends StateNotifier<AuthState> {
  late SharedPreferences _prefs;

  AuthNotifier() : super(const AuthState()) {
    _initialize();
  }

  Future<void> _initialize() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadAuth();
  }

  Future<void> _loadAuth() async {
    try {
      final isLoggedIn = _prefs.getBool('isLoggedIn') ?? false;
      final email = _prefs.getString('userEmail');
      final name = _prefs.getString('userName');
      final token = _prefs.getString('authToken');

      state = AuthState(
        isLoggedIn: isLoggedIn,
        userEmail: email,
        userName: name,
        authToken: token,
      );
    } catch (e) {
      debugPrint('[AuthNotifier] Error loading auth: $e');
    }
  }

  Future<void> login(String email, String password) async {
    try {
      // TODO: Implement actual API call
      // For now, just store locally
      await _prefs.setBool('isLoggedIn', true);
      await _prefs.setString('userEmail', email);
      await _prefs.setString('authToken', 'dummy_token_${DateTime.now().millisecondsSinceEpoch}');

      state = state.copyWith(
        isLoggedIn: true,
        userEmail: email,
        authToken: 'dummy_token_${DateTime.now().millisecondsSinceEpoch}',
      );
    } catch (e) {
      debugPrint('[AuthNotifier] Login error: $e');
      rethrow;
    }
  }

  Future<void> signup(String name, String email, String password) async {
    try {
      // TODO: Implement actual API call
      await _prefs.setBool('isLoggedIn', true);
      await _prefs.setString('userName', name);
      await _prefs.setString('userEmail', email);
      await _prefs.setString('authToken', 'dummy_token_${DateTime.now().millisecondsSinceEpoch}');

      state = state.copyWith(
        isLoggedIn: true,
        userName: name,
        userEmail: email,
        authToken: 'dummy_token_${DateTime.now().millisecondsSinceEpoch}',
      );
    } catch (e) {
      debugPrint('[AuthNotifier] Signup error: $e');
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await _prefs.setBool('isLoggedIn', false);
      await _prefs.remove('userEmail');
      await _prefs.remove('userName');
      await _prefs.remove('authToken');

      state = const AuthState(isLoggedIn: false);
    } catch (e) {
      debugPrint('[AuthNotifier] Logout error: $e');
      rethrow;
    }
  }
}

/// Auth provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

/// Individual auth providers
final isLoggedInProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isLoggedIn;
});

final userEmailProvider = Provider<String?>((ref) {
  return ref.watch(authProvider).userEmail;
});

final userNameProvider = Provider<String?>((ref) {
  return ref.watch(authProvider).userName;
});
