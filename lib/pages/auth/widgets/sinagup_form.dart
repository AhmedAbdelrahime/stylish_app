import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/pages/auth/screens/forgot_password.dart';
import 'package:hungry/pages/auth/widgets/custom_auth_textfiled.dart';
import 'package:hungry/shared/custom_text.dart';

class SinagupForm extends StatelessWidget {
  const SinagupForm({
    super.key,
    required this.emailControler,
    required this.passControler,
    required this.confirmControler,
  });
  final TextEditingController emailControler;
  final TextEditingController passControler;
  final TextEditingController confirmControler;

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
        Gap(15),
        CustomAuthTextfiled(
          keyboardType: TextInputType.visiblePassword,
          controller: confirmControler,
          labelText: ' Confirm Password',
          icone: Icons.lock,
          isPassowed: true,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your password';
            }
            if (value != passControler.text) {
              return 'Password must Machted ';
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
              text:
                  'By clicking the Register button, you agree to the public offer',
              size: 13,
              weight: FontWeight.w400,
              color: AppColors.grayColor,
            ),
          ),
        ),
      ],
    );
  }
}
