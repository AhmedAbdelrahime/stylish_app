import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/l10n/app_localizations.dart';
import 'package:hungry/pages/auth/screens/login_screen.dart';
import 'package:hungry/pages/auth/screens/singup_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum _AuthChoice { login, signUp }

class AuthNavigation {
  const AuthNavigation._();

  static bool get isSignedIn =>
      Supabase.instance.client.auth.currentUser != null;

  static Future<bool> requireAuth(
    BuildContext context, {
    String title = 'Sign in to continue',
    String message =
        'You can browse and add items as a guest. Sign in when you are ready to manage your account or place an order.',
  }) async {
    if (isSignedIn) {
      return true;
    }

    final choice = await showModalBottomSheet<_AuthChoice>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 18, 22, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    color: AppColors.redColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.lock_outline_rounded,
                    color: AppColors.redColor,
                  ),
                ),
                const Gap(16),
                Text(
                  context.tr(title),
                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                    color: AppColors.blackColor,
                  ),
                ),
                const Gap(8),
                Text(
                  context.tr(message),
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.45,
                    color: AppColors.hintColor.withValues(alpha: 0.95),
                  ),
                ),
                const Gap(20),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () => Navigator.pop(context, _AuthChoice.login),
                    icon: const Icon(Icons.login_rounded),
                    label: Text(context.tr('Login')),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.redColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
                const Gap(10),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.pop(context, _AuthChoice.signUp),
                    icon: const Icon(Icons.person_add_alt_1_rounded),
                    label: Text(context.tr('Create Account')),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.blackColor,
                      side: BorderSide(
                        color: Colors.black.withValues(alpha: 0.16),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
                const Gap(8),
                Center(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(context.tr('Continue browsing')),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (!context.mounted || choice == null) {
      return false;
    }

    final authenticated = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => choice == _AuthChoice.login
            ? const LoginScreen(returnToPrevious: true)
            : const SingupScreen(returnToPrevious: true),
      ),
    );

    return authenticated == true || isSignedIn;
  }
}
