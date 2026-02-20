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

class SingupScreen extends StatefulWidget {
  const SingupScreen({super.key});

  @override
  State<SingupScreen> createState() => _SingupScreenState();
}

class _SingupScreenState extends State<SingupScreen> {
  final TextEditingController _emailControler = TextEditingController();
  final TextEditingController _passControler = TextEditingController();
  final TextEditingController _confirmControler = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isloading = false;
  final _authService = AuthService();

  @override
  void dispose() {
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

                    OtherLogin(),
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
