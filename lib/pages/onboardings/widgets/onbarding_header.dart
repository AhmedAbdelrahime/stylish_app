import 'package:flutter/material.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/pages/onboardings/get_start_page.dart';
import 'package:hungry/shared/custom_text.dart';

class OnbardingHeader extends StatelessWidget {
  const OnbardingHeader({super.key, required this.count});
  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomText(text: count.toString(), size: 18, weight: FontWeight.w600),
        CustomText(
          text: '/3',
          size: 18,
          weight: FontWeight.w600,
          color: AppColors.grayColor,
        ),
        Spacer(),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => GetStartPage()),
            );
          },

          child: CustomText(text: 'Skip', size: 18, weight: FontWeight.w600),
        ),
      ],
    );
  }
}
