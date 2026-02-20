import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> signUp({required String email, required String password}) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
      );

      final user = response.user;

      if (kDebugMode) {
        print('User created: $user');
      }

      if (user != null) {
        await _supabase
            .from('profiles')
            .upsert({'id': user.id, 'email': email})
            .eq('id', user.id);

        if (kDebugMode) {
          print(user);
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

      final user = response.user;

      if (kDebugMode) {
        print('User Login: $user');
      }
    } catch (error) {
      throw error.toString();
      // rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
      if (kDebugMode) {
        print('User signed out');
      }
    } catch (error) {
      throw error.toString();
    }
  } 

  Future<void> forgotPassword({required String email}) async {
    try {
      // 🔍 1. Check email in profiles table
      final response = await _supabase
          .from('profiles')
          .select('id')
          .eq('email', email)
          .maybeSingle();
      print(response);

      if (response == null) {
        print(response);
        throw 'No account found with this email';
      }

      // 📧 2. Send reset email
      await _supabase.auth.resetPasswordForEmail(
        email,
        redirectTo: 'io.supabase.hungry://reset-password',
      );

      if (kDebugMode) {
        print('Reset password email sent');
      }
    } catch (error) {
      throw error.toString();
    }
  }

  Future<void> updatePassword({required String newPassword}) async {
    try {
      await _supabase.auth.updateUser(UserAttributes(password: newPassword));

      if (kDebugMode) {
        print('Password updated successfully');
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

    await _supabase.auth.updateUser(
      UserAttributes(
        password: newPassword,
      ),
    );
  }
}
