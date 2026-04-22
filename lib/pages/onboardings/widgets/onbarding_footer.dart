import 'package:flutter/material.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/pages/onboardings/get_start_page.dart';
import 'package:hungry/pages/onboardings/models/onboarding_model.dart';
import 'package:hungry/pages/onboardings/services/onbordingserv.dart';
import 'package:hungry/shared/custom_text.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnbardingFooter extends StatelessWidget {
  const OnbardingFooter({
    super.key,
    required this.isFrist,
    required this.islast,
    required this.controller,
  });
  final bool isFrist;
  final bool islast;
  final PageController controller;

  void _animateToPreviousPage() {
    controller.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _animateToNextPage() {
    controller.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        isFrist
            ? SizedBox.shrink()
            : GestureDetector(
                onTap: _animateToPreviousPage,
                child: CustomText(
                  text: 'Back',
                  size: 18,
                  weight: FontWeight.w600,
                  color: AppColors.grayColor,
                ),
              ),
        SmoothPageIndicator(
          controller: controller,
          count: onboarding.length,
          effect: const ExpandingDotsEffect(
            dotHeight: 10,
            dotWidth: 8,
            expansionFactor: 3,
            activeDotColor: AppColors.blackColor,
          ),
        ),
        islast
            ? GestureDetector(
                onTap: () async {
                  await OnboardingService.setSeenOnboarding();
                  if (!context.mounted) return;
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const GetStartPage(),
                    ),
                  );
                },
                child: CustomText(
                  text: 'Get Started',
                  size: 18,
                  weight: FontWeight.w600,
                  color: AppColors.redColor,
                ),
              )
            : GestureDetector(
                onTap: _animateToNextPage,
                child: CustomText(
                  text: 'Next',
                  size: 18,
                  weight: FontWeight.w600,
                  color: AppColors.redColor,
                ),
              ),
      ],
    );
  }
}
