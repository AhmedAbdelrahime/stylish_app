import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hungry/core/api/supabase_error_mapper.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/pages/auth/data/auth_service.dart';
import 'package:hungry/pages/auth/screens/login_screen.dart';
import 'package:hungry/pages/auth/widgets/app_snackbar.dart';
import 'package:hungry/pages/auth/widgets/auth_header.dart';
import 'package:hungry/pages/auth/widgets/reset_password_form.dart';
import 'package:hungry/shared/custom_button.dart';
import 'package:hungry/shared/custom_text.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final TextEditingController _passControler = TextEditingController();
  final TextEditingController _confirmControler = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isloading = false;
  final _authService = AuthService();

  @override
  void dispose() {
    _passControler.dispose();
    _confirmControler.dispose();
    super.dispose();
  }

  Future<void> resetPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isloading = true;
      });
      try {
        await _authService.updatePassword(newPassword: _passControler.text);
        if (!mounted) return;

        AppSnackBar.show(
          context: context,
          text: 'Password updated successfully',
          backgroundColor: Colors.green,
          icon: Icons.check_circle_outline,
        );
        setState(() {
          isloading = false;
        });

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      } catch (e) {
        if (!mounted) return;
        final readableMessage = SupabaseErrorMapper.map(e);

        AppSnackBar.show(
          context: context,
          text: readableMessage,
          icon: Icons.error_outline_rounded,
          backgroundColor: Colors.red,
        );
        setState(() {
          isloading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        backgroundColor: AppColors.primaryColor,
        appBar: AppBar(backgroundColor: AppColors.primaryColor),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AuthHeader(text1: 'Reset', text2: 'password?'),
              Gap(50),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    ResetPasswordForm(
                      passControler: _passControler,
                      confirmControler: _confirmControler,
                      formKey: _formKey,
                    ),

                    Gap(30),
                    Row(
                      // crossAxisAlignment: ,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: '*',
                          size: 20,
                          weight: FontWeight.bold,
                          color: AppColors.redColor,
                        ),
                        Expanded(
                          child: CustomText(
                            text:
                                'We will send you a message to set or reset your new password',
                            size: 14,
                            weight: FontWeight.w500,
                            color: AppColors.hintColor,
                          ),
                        ),
                      ],
                    ),
                    Gap(20),
                    isloading
                        ? CupertinoActivityIndicator(
                            color: AppColors.redColor,
                            radius: 20,
                          )
                        : CustomButton(
                            ontap: resetPassword,
                            text: "Reset Password",
                          ),

                    Gap(20),
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
