
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/pages/product/model/product_model.dart';
import 'package:hungry/shared/custom_text.dart';

class PolicyWidget extends StatelessWidget {
  const PolicyWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        privacy.length,
        (index) => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: AppColors.grayColor),
          ),
          margin: EdgeInsets.only(right: 7),
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          child: Row(
            children: [
              Icon(privacy[index].icon, color: AppColors.hintColor),
              Gap(2),
              CustomText(
                text: privacy[index].text,
                size: 12,
                weight: FontWeight.w400,
                color: AppColors.hintColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
