import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/pages/auth/screens/login_screen.dart';
import 'package:hungry/pages/onboardings/services/onbordingserv.dart';
import 'package:hungry/shared/custom_button.dart';
import 'package:hungry/shared/custom_text.dart';

class GetStartPage extends StatelessWidget {
  const GetStartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,

            image: AssetImage('assets/images/get_start.png'),
          ),
        ),

        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Container(
            // decoration: BoxDecoration(
            //   gradient: LinearGradient(
            //     // begin: Alignment(0.50, -0.00),
            //     // end: Alignment(0.50, 1.00),
            //     colors: [
            //       Colors.black.withValues(alpha: 0),
            //       Colors.black.withValues(alpha: 0.63),
            //     ],
            //   ),
            // ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomText(
                  text: 'You want Authentic, here you go!',
                  size: 30,
                  weight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
                Gap(10),
                CustomText(
                  text: 'Find it here, buy it now!',
                  size: 14,
                  weight: FontWeight.w400,
                  color: AppColors.primaryColor,
                ),
                Gap(20),

                CustomButton(
                  ontap: () async {
                    await OnboardingService.setSeenOnboarding();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    );
                  },
                  text: 'Get Start',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
