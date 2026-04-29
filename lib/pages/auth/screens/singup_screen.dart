<<<<<<< HEAD
import 'dart:async';

=======
>>>>>>> 71e363e9e57e6f331681c6680a26430d8356d3c8
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hungry/core/api/supabase_error_mapper.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/pages/auth/data/auth_gate.dart';
import 'package:hungry/pages/auth/data/auth_service.dart';
import 'package:hungry/pages/auth/screens/login_screen.dart';
import 'package:hungry/pages/auth/widgets/app_snackbar.dart';
import 'package:hungry/pages/auth/widgets/auth_header.dart';
import 'package:hungry/pages/auth/widgets/footer_text.dart';
import 'package:hungry/pages/auth/widgets/other_login.dart';
import 'package:hungry/pages/auth/widgets/sinagup_form.dart';
import 'package:hungry/shared/custom_button.dart';
<<<<<<< HEAD
import 'package:supabase_flutter/supabase_flutter.dart';
=======
>>>>>>> 71e363e9e57e6f331681c6680a26430d8356d3c8

class SingupScreen extends StatefulWidget {
  const SingupScreen({super.key});

  @override
  State<SingupScreen> createState() => _SingupScreenState();
}

class _SingupScreenState extends State<SingupScreen> {
  final TextEditingController _nameControler = TextEditingController();
  final TextEditingController _emailControler = TextEditingController();
  final TextEditingController _passControler = TextEditingController();
  final TextEditingController _confirmControler = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isloading = false;
<<<<<<< HEAD
  bool _isGoogleLoading = false;
  bool _isWaitingForGoogleAuth = false;
  final _authService = AuthService();
  late final StreamSubscription<AuthState> _authSubscription;

  @override
  void dispose() {
    _authSubscription.cancel();
=======
  final _authService = AuthService();

  @override
  void dispose() {
>>>>>>> 71e363e9e57e6f331681c6680a26430d8356d3c8
    _nameControler.dispose();
    _emailControler.dispose();
    _passControler.dispose();
    _confirmControler.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isloading = true);

    try {
      await _authService.signUp(
        fullName: _nameControler.text.trim(),
        email: _emailControler.text.trim(),
        password: _passControler.text.trim(),
      );
      // signup success

      if (!mounted) return;

      AppSnackBar.show(
        context: context,
        text: 'Account created successfully',
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

<<<<<<< HEAD
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

=======
>>>>>>> 71e363e9e57e6f331681c6680a26430d8356d3c8
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        backgroundColor: AppColors.primaryColor,
        body: Padding(
          padding: const EdgeInsets.only(top: 80, right: 30, left: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AuthHeader(text1: 'Create an ', text2: 'account'),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    SinagupForm(
                      nameControler: _nameControler,
                      emailControler: _emailControler,
                      passControler: _passControler,
                      confirmControler: _confirmControler,
                    ),
                    Gap(30),
                    _isloading
                        ? CupertinoActivityIndicator(
                            color: AppColors.redColor,
                            radius: 20,
                          )
                        : CustomButton(ontap: _signUp, text: "Create Account"),

<<<<<<< HEAD
                    OtherLogin(
                      onGoogleTap: _isloading ? null : _signInWithGoogle,
                      isGoogleLoading: _isGoogleLoading,
                    ),
=======
                    OtherLogin(),
>>>>>>> 71e363e9e57e6f331681c6680a26430d8356d3c8
                    Gap(20),
                    FoooterText(
                      text1: 'I Already Have an Account',
                      text2: 'Login',
                      onTap: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
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
