import 'package:flutter/foundation.dart';

class SupabaseErrorMapper {
  static String map(dynamic error) {
    // LOGIN
    if (error.contains('Invalid login credentials')) {
      return 'Email or password is incorrect';
    }

    if (error.contains('Email not confirmed')) {
      return 'Please verify your email before logging in';
    }

    // SIGN UP
    if (error.contains('User already registered')) {
      return 'This email is already registered';
    }

    if (error.contains('Password should be at least')) {
      return 'Password is too weak';
    }

    if (error.contains('Signup is disabled')) {
      return 'Account creation is currently disabled';
    }
    // forgot PASSWORD
    if (error.contains('No account found with this email')) {
      return 'No account found with this email';
    }
    if (error.contains(
      'New password should be different from the old password',
    )) {
      return ' New password should be different \n from the old password';
    }

    // SESSION
    if (error.contains('JWT expired')) {
      return 'Session expired. Please login again';
    }
    if (error.contains('duplicate key')) {
      return 'This record already exists';
    }
    if (error.contains('duplicate key')) {
      return 'This record already exists';
    }
    if (error.contains('User already registered')) {
      return 'This email is already registered';
    }

    if (error.contains('violates row-level security')) {
      return 'You are not allowed to perform this action';
    }

    if (error.contains('null value')) {
      return 'Required information is missing';
    }
    if (error.contains('This record already exists')) {
      return 'This record already exists';
    }
    // 🌐 No internet / DNS / host lookup
    if (error.contains('ClientException with SocketException')) {
      return 'No internet connection.';
    }

    // 🌐 Retryable network errors (Supabase)
    if (error.contains('Failed host lookup') ||
        error.contains('Connection timed out') ||
        error.contains('Network is unreachable')) {
      return 'Unable to connect to server. \nPlease try again later.';
    }
    if (error.contains('User not logged in')) {
      return 'User not logged in';
    }
    if (kDebugMode) {
      debugPrint(error.toString());
    }
    // ❓ Unknown
    return 'Something went wrong. Please try again.';

    // return _mapDatabaseError(error.message.toString());

    // return error.toString();
  }
}
