import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/pages/auth/screens/login_screen.dart';
import 'package:hungry/pages/auth/screens/rest_password.dart';
import 'package:hungry/pages/onboardings/onboarding.dart';
import 'package:hungry/pages/onboardings/services/onbordingserv.dart';
import 'package:hungry/root.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;

    return StreamBuilder<AuthState>(
      stream: supabase.auth.onAuthStateChange,
      builder: (context, snapshot) {
        final session = snapshot.data?.session; // ✅ FIX

        final event = snapshot.data?.event;
        // 🔐 PASSWORD RECOVERY EVENT

        if (event == AuthChangeEvent.passwordRecovery) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ResetPassword(),));
          });
        }

        // Loading only on very first frame
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator(
              color: AppColors.redColor,
              
              


            )),
          );
        }

        // USER LOGGED IN
        if (session != null) {
          return const Root();
        }

        // USER NOT LOGGED IN → CHECK ONBOARDING
        return FutureBuilder<bool>(
          future: OnboardingService.hasSeenOnboarding(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CupertinoActivityIndicator(radius: 20)),
              );
            }

            if (snapshot.data == false) {
              return const OnboardingScreen();
            }

            return const LoginScreen();
          },
        );
      },
    );
  }
}
