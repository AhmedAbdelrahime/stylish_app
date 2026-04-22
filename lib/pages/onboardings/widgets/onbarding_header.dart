import 'package:flutter/material.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/shared/custom_text.dart';

class OnbardingHeader extends StatelessWidget {
  const OnbardingHeader({super.key, required this.count, required this.onSkip});
  final int count;
  final Future<void> Function() onSkip;

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
          onTap: onSkip,
          child: CustomText(text: 'Skip', size: 18, weight: FontWeight.w600),
        ),
      ],
    );
  }
}
