import 'package:flutter/foundation.dart';

class SupabaseErrorMapper {
  static String map(dynamic error) {
<<<<<<< HEAD
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
=======
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
>>>>>>> 71e363e9e57e6f331681c6680a26430d8356d3c8
      'New password should be different from the old password',
    )) {
      return ' New password should be different \n from the old password';
    }

    // SESSION
<<<<<<< HEAD
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
=======
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
>>>>>>> 71e363e9e57e6f331681c6680a26430d8356d3c8
      return 'No internet connection.';
    }

    // 🌐 Retryable network errors (Supabase)
<<<<<<< HEAD
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
=======
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
>>>>>>> 71e363e9e57e6f331681c6680a26430d8356d3c8
    }
    // ❓ Unknown
    return 'Something went wrong. Please try again.';

    // return _mapDatabaseError(error.message.toString());

    // return error.toString();
  }
}
