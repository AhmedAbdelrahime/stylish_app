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
      body: DecoratedBox(
        decoration: BoxDecoration(
          image: const DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage('assets/images/get_start.png'),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CustomText(
                text: 'Everything you need, all in one place.',
                size: 30,
                weight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
              const Gap(10),
              CustomText(
                text:
                    'Shop smart, checkout fast, and enjoy a better way to buy.',
                size: 14,
                weight: FontWeight.w400,
                color: AppColors.primaryColor,
              ),
              const Gap(20),
              CustomButton(
                ontap: () async {
                  await OnboardingService.setSeenOnboarding();
                  if (!context.mounted) return;
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                },
                text: 'Get Started',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
