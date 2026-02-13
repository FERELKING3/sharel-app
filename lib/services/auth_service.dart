import 'package:flutter/foundation.dart';

/// Service d'authentification
class AuthService {
  /// Valider email
  bool isValidEmail(String email) {
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    return regex.hasMatch(email);
  }

  /// Valider password (min 8 characters)
  bool isValidPassword(String password) {
    return password.length >= 8;
  }

  /// Login stub - TODO: implement actual API call
  Future<AuthResponse> login(String email, String password) async {
    debugPrint('[AuthService] Login attempt: $email');

    if (!isValidEmail(email)) {
      return const AuthResponse(
        success: false,
        error: 'Email invalide',
      );
    }

    if (!isValidPassword(password)) {
      return const AuthResponse(
        success: false,
        error: 'Mot de passe doit contenir minimum 8 caractères',
      );
    }

    // TODO: Call actual API
    await Future.delayed(const Duration(seconds: 1));

    return AuthResponse(
      success: true,
      token: 'token_${DateTime.now().millisecondsSinceEpoch}',
      user: AuthUser(
        id: 'user_001',
        email: email,
        name: email.split('@').first,
      ),
    );
  }

  /// Signup stub - TODO: implement actual API call
  Future<AuthResponse> signup(
    String name,
    String email,
    String password,
  ) async {
    debugPrint('[AuthService] Signup attempt: $email');

    if (name.isEmpty) {
      return const AuthResponse(
        success: false,
        error: 'Le nom ne peut pas être vide',
      );
    }

    if (!isValidEmail(email)) {
      return const AuthResponse(
        success: false,
        error: 'Email invalide',
      );
    }

    if (!isValidPassword(password)) {
      return const AuthResponse(
        success: false,
        error: 'Mot de passe doit contenir minimum 8 caractères',
      );
    }

    // TODO: Call actual API
    await Future.delayed(const Duration(seconds: 1));

    return AuthResponse(
      success: true,
      token: 'token_${DateTime.now().millisecondsSinceEpoch}',
      user: AuthUser(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        name: name,
      ),
    );
  }

  /// Logout
  Future<void> logout() async {
    debugPrint('[AuthService] Logout');
    await Future.delayed(const Duration(milliseconds: 500));
  }

  /// Verifier token
  Future<bool> verifyToken(String token) async {
    debugPrint('[AuthService] Verifying token');
    // TODO: Call actual API
    return true;
  }
}

/// Auth response
class AuthResponse {
  final bool success;
  final String? error;
  final String? token;
  final AuthUser? user;

  const AuthResponse({
    required this.success,
    this.error,
    this.token,
    this.user,
  });
}

/// Auth user
class AuthUser {
  final String id;
  final String email;
  final String name;
  final String? avatarUrl;

  const AuthUser({
    required this.id,
    required this.email,
    required this.name,
    this.avatarUrl,
  });
}
