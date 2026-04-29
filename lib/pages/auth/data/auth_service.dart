import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  static const String oauthRedirectTo = 'io.supabase.hungry://login-callback';

  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': fullName},
      );

      final user = response.user;

      if (kDebugMode) {
        debugPrint('User created: $user');
      }

      if (user != null) {
        try {
          await _supabase.from('profiles').upsert({
            'id': user.id,
            'email': email,
            'full_name': fullName,
          });
        } catch (error) {
          if (kDebugMode) {
            debugPrint('Profile sync skipped after sign up: $error');
          }
        }

        if (kDebugMode) {
          debugPrint(user.toString());
        }
      }
    } catch (error) {
      throw error.toString();
    }
  }

  Future<void> signIn({required String email, required String password}) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (kDebugMode) {
        debugPrint('User Login: ${response.user}');
      }
    } catch (error) {
      throw error.toString();
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      final didOpenAuthScreen = await _supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: oauthRedirectTo,
        authScreenLaunchMode: LaunchMode.externalApplication,
      );

      if (!didOpenAuthScreen) {
        throw 'Could not open Google sign in';
      }
    } catch (error) {
      throw error.toString();
    }
  }

  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
      if (kDebugMode) {
        debugPrint('User signed out');
      }
    } catch (error) {
      throw error.toString();
    }
  }

  Future<void> forgotPassword({required String email}) async {
    try {
      await _supabase.auth.resetPasswordForEmail(
        email,
        redirectTo: 'io.supabase.hungry://reset-password',
      );

      if (kDebugMode) {
        debugPrint('Reset password email sent');
      }
    } catch (error) {
      throw error.toString();
    }
  }

  Future<void> updatePassword({required String newPassword}) async {
    try {
      await _supabase.auth.updateUser(UserAttributes(password: newPassword));

      if (kDebugMode) {
        debugPrint('Password updated successfully');
      }
    } catch (error) {
      throw error.toString();
    }
  }

  Future<void> changePassword(String newPassword) async {
    final user = _supabase.auth.currentUser;

    if (user == null) {
      throw 'User not logged in';
    }

    await _supabase.auth.updateUser(UserAttributes(password: newPassword));
  }
}
