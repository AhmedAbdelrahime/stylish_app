import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hungry/core/api/supabase_error_mapper.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/pages/auth/data/auth_gate.dart';
import 'package:hungry/pages/auth/data/auth_service.dart';
import 'package:hungry/pages/auth/screens/singup_screen.dart';
import 'package:hungry/pages/auth/widgets/app_snackbar.dart';
import 'package:hungry/pages/auth/widgets/footer_text.dart';
import 'package:hungry/pages/auth/widgets/login_form.dart';
import 'package:hungry/pages/auth/widgets/other_login.dart';
import 'package:hungry/shared/custom_button.dart';
import 'package:hungry/shared/custom_text.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailControler = TextEditingController();
  TextEditingController passControler = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isloading = false;
  bool _isGoogleLoading = false;
  bool _isWaitingForGoogleAuth = false;
  final _authService = AuthService();
  late final StreamSubscription<AuthState> _authSubscription;

  @override
  void dispose() {
    _authSubscription.cancel();
    emailControler.dispose();
    passControler.dispose();
    super.dispose();
  }

  Future<void> _logIn() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isloading = true);

    try {
      await _authService.signIn(
        email: emailControler.text.trim(),
        password: passControler.text.trim(),
      );
      // login success

      if (!mounted) return;

      AppSnackBar.show(
        context: context,
        text: 'Login successful',
        icon: Icons.check_circle_outline,
        backgroundColor: Colors.green,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => AuthGate()),
      );
    } catch (e) {
      final readableMessage = SupabaseErrorMapper.map(e);

      AppSnackBar.show(
        context: context,
        text: readableMessage,
        icon: Icons.error_outline_rounded,
        backgroundColor: Colors.red,
      );
    } finally {
      if (mounted) setState(() => _isloading = false);
    }
  }

  Future<void> _signInWithGoogle() async {
    if (_isGoogleLoading) return;

    setState(() {
      _isGoogleLoading = true;
      _isWaitingForGoogleAuth = true;
    });

    try {
      await _authService.signInWithGoogle();
    } catch (e) {
      _isWaitingForGoogleAuth = false;
      if (!mounted) return;

      final readableMessage = SupabaseErrorMapper.map(e);

      AppSnackBar.show(
        context: context,
        text: readableMessage,
        icon: Icons.error_outline_rounded,
        backgroundColor: Colors.red,
      );
    } finally {
      if (mounted) setState(() => _isGoogleLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _authSubscription = Supabase.instance.client.auth.onAuthStateChange.listen((
      data,
    ) {
      if (!_isWaitingForGoogleAuth ||
          data.event != AuthChangeEvent.signedIn ||
          !mounted) {
        return;
      }

      _isWaitingForGoogleAuth = false;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const AuthGate()),
        (route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        backgroundColor: AppColors.primaryColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(text: 'Welcome', size: 30, weight: FontWeight.bold),
              CustomText(text: 'Back!', size: 30, weight: FontWeight.bold),
              Gap(20),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    LoginForm(
                      emailControler: emailControler,
                      passControler: passControler,
                    ),
                    Gap(30),
                    _isloading
                        ? CupertinoActivityIndicator(
                            color: AppColors.redColor,
                            radius: 20,
                          )
                        : CustomButton(ontap: _logIn, text: "Login"),

                    OtherLogin(
                      onGoogleTap: _isloading ? null : _signInWithGoogle,
                      isGoogleLoading: _isGoogleLoading,
                    ),
                    Gap(20),
                    FoooterText(
                      text1: 'Create An Account',
                      text2: 'Sign Up',
                      onTap: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => SingupScreen()),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
