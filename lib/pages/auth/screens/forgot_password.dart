import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hungry/core/api/supabase_error_mapper.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/pages/auth/data/auth_service.dart';
import 'package:hungry/pages/auth/widgets/app_snackbar.dart';
import 'package:hungry/pages/auth/widgets/auth_header.dart';
import 'package:hungry/pages/auth/widgets/custom_auth_textfiled.dart';
import 'package:hungry/shared/custom_button.dart';
import 'package:hungry/shared/custom_text.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController emailControler = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isloading = false;
  final _authService = AuthService();

  @override
  void dispose() {
    emailControler.dispose();
    super.dispose();
  }

  Future<void> forgotPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isloading = true;
      });
      try {
        await _authService.forgotPassword(email: emailControler.text);

        setState(() {
          isloading = false;
        });
          AppSnackBar.show(
    context: context,
    text: 'Password reset email sent',
    icon: Icons.email_outlined,
    backgroundColor: Colors.green,
  );
      } catch (e) {
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
              AuthHeader(text1: 'Forgot', text2: 'password?'),
              Gap(50),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomAuthTextfiled(
                      keyboardType: TextInputType.emailAddress,
                      controller: emailControler,
                      labelText: 'Enter your email address',
                      icone: Icons.email,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email ';
                        }

                        if (value.length > 50) {
                          return 'Email  cannot be more than 50 characters';
                        }
                        if (value.length < 5) {
                          return 'Email  must be at least 5 characters';
                        }
                        return null;
                      },
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
                              radius: 25,
                            )
                          :
  CustomButton(ontap: forgotPassword, text: "Submit"),

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
