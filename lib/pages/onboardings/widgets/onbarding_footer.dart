import 'package:flutter/material.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/pages/onboardings/get_start_page.dart';
import 'package:hungry/pages/onboardings/models/onboarding_model.dart';
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

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        isFrist
            ? SizedBox.shrink()
            : GestureDetector(
                onTap: () {
                  controller.previousPage(
                    duration: const Duration(microseconds: 500),
                    curve: Curves.easeInOut,
                  );
                },
                child: CustomText(
                  text: 'Prev',
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
                onTap: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => GetStartPage(),));
                },
                child: CustomText(
                  text: 'Get Start',
                  size: 18,
                  weight: FontWeight.w600,
                  color: AppColors.redColor,
                ),
              )
            : GestureDetector(
                onTap: () {
                  controller.nextPage(
                    duration: const Duration(microseconds: 500),
                    curve: Curves.easeInOut,
                  );
                },
                child: GestureDetector(
                  onTap: () {
                    controller.nextPage(
                      duration: const Duration(microseconds: 500),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: CustomText(
                    text: 'Next',
                    size: 18,
                    weight: FontWeight.w600,
                    color: AppColors.redColor,
                  ),
                ),
              ),
      ],
    );
  }
}
