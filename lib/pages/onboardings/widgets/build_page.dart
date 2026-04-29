import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/pages/onboardings/models/onboarding_model.dart';
import 'package:hungry/shared/custom_text.dart';

class BuildPage extends StatelessWidget {
  const BuildPage({super.key, required this.onbordings});
  final OnboardingModel onbordings;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 60, bottom: 40),
          child: SvgPicture.asset(onbordings.image),
        ),
        CustomText(text: onbordings.title, size: 24, weight: FontWeight.bold),
        SizedBox(height: 15),
        CustomText(
          text: onbordings.description,

          size: 18,
          weight: FontWeight.w400,
          color: AppColors.grayColor,
        ),
      ],
    );
  }
}
