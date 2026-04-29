import 'package:flutter/foundation.dart';

class SupabaseErrorMapper {
  static String map(dynamic error) {
    final message = error.toString();

    // LOGIN
    if (message.contains('Invalid login credentials')) {
      return 'Email or password is incorrect';
    }

    if (message.contains('Email not confirmed')) {
      return 'Please verify your email before logging in';
    }

    if (message.contains('Could not open Google sign in')) {
      return 'Could not open Google sign-in';
    }

    if (message.contains('provider is not enabled') ||
        message.contains('Unsupported provider')) {
      return 'Google sign-in is not enabled yet';
    }

    // SIGN UP
    if (message.contains('User already registered')) {
      return 'This email is already registered';
    }

    if (message.contains('Password should be at least')) {
      return 'Password is too weak';
    }

    if (message.contains('Signup is disabled')) {
      return 'Account creation is currently disabled';
    }
    // forgot PASSWORD
    if (message.contains('No account found with this email')) {
      return 'No account found with this email';
    }
    if (message.contains(
      'New password should be different from the old password',
    )) {
      return ' New password should be different \n from the old password';
    }

    // SESSION
    if (message.contains('JWT expired')) {
      return 'Session expired. Please login again';
    }
    if (message.contains('duplicate key')) {
      return 'This record already exists';
    }
    if (message.contains('duplicate key')) {
      return 'This record already exists';
    }
    if (message.contains('User already registered')) {
      return 'This email is already registered';
    }

    if (message.contains('violates row-level security')) {
      return 'You are not allowed to perform this action';
    }

    if (message.contains('null value')) {
      return 'Required information is missing';
    }
    if (message.contains('This record already exists')) {
      return 'This record already exists';
    }
    // 🌐 No internet / DNS / host lookup
    if (message.contains('ClientException with SocketException')) {
      return 'No internet connection.';
    }

    // 🌐 Retryable network errors (Supabase)
    if (message.contains('Failed host lookup') ||
        message.contains('Connection timed out') ||
        message.contains('Network is unreachable')) {
      return 'Unable to connect to server. \nPlease try again later.';
    }
    if (message.contains('User not logged in')) {
      return 'User not logged in';
    }
    if (kDebugMode) {
      debugPrint(message);
    }
    // ❓ Unknown
    return 'Something went wrong. Please try again.';

    // return _mapDatabaseError(error.message.toString());

    // return error.toString();
  }
}
