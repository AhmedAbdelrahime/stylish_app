import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/pages/auth/screens/forgot_password.dart';
import 'package:hungry/pages/auth/widgets/custom_auth_textfiled.dart';
import 'package:hungry/shared/custom_text.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    super.key,
    required this.emailControler,
    required this.passControler,
  });
  final TextEditingController emailControler;
  final TextEditingController passControler;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomAuthTextfiled(
          keyboardType: TextInputType.emailAddress,
          controller: emailControler,
          labelText: 'Username or Email',
          icone: Icons.person,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email or username';
            }

            if (value.length > 50) {
              return 'Email or username cannot be more than 50 characters';
            }
            if (value.length < 5) {
              return 'Email or username must be at least 5 characters';
            }
            return null;
          },
        ),
        Gap(15),
        CustomAuthTextfiled(
          keyboardType: TextInputType.visiblePassword,
          controller: passControler,
          labelText: 'Password',
          icone: Icons.lock,
          isPassowed: true,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your password';
            }
            if (value.length < 8) {
              return 'Password must be at least 8 characters';
            }
            if (value.length > 20) {
              return 'Password cannot be more than 20 characters';
            }
            return null;
          },
        ),
        Gap(10),
        Align(
          alignment: AlignmentGeometry.centerRight,
          child: GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ForgotPassword()),
            ),
            child: CustomText(
              text: 'Forget Password?',
              size: 14,
              weight: FontWeight.w400,
              color: AppColors.redColor,
            ),
          ),
        ),
      ],
    );
  }
}
