import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/shared/custom_text.dart';

class PaySection extends StatelessWidget {
  const PaySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SvgPicture.asset(
              'assets/svgs/coupon.svg',
              width: 20,
              height: 20,
              color: AppColors.blackColor,
            ),
            Gap(10),
            CustomText(
              text: 'Apply Coupons',
              size: 16,
              weight: FontWeight.w600,
            ),
            Spacer(),
            CustomText(
              text: 'Select ',
              size: 14,
              weight: FontWeight.w500,
              color: AppColors.redColor,
            ),
          ],
        ),
        Gap(20),
        Divider(color: Colors.grey.withOpacity(0.5)),
        Gap(20),
        CustomText(
          text: 'Order Payment Details',
          size: 18,
          weight: FontWeight.w400,
        ),
        Gap(20),
        Row(
          children: [
            CustomText(
              text: 'Order Amounts',
              size: 16,
              weight: FontWeight.w400,
            ),
            Spacer(),
            CustomText(
              text: '\$7,000.00',
              size: 15,
              weight: FontWeight.w500,
              color: AppColors.blackColor,
            ),
          ],
        ),
        Gap(20),
        Row(
          children: [
            CustomText(text: 'Convenience', size: 16, weight: FontWeight.w400),
            Gap(10),
            CustomText(
              text: 'Know More',
              size: 13,
              weight: FontWeight.w500,
              color: AppColors.redColor,
            ),
            Spacer(),
            CustomText(
              text: 'Apply Coupon',
              size: 13,
              weight: FontWeight.w500,
              color: AppColors.redColor,
            ),
          ],
        ),
        Gap(20),
        Row(
          children: [
            CustomText(text: 'Delivery Fee', size: 16, weight: FontWeight.w400),

            Spacer(),
            CustomText(
              text: 'Free',
              size: 14,
              weight: FontWeight.w500,
              color: AppColors.redColor,
            ),
          ],
        ),
        Divider(color: Colors.grey.withOpacity(0.5)),
        Gap(10),
        CustomText(text: 'Order Total', size: 18, weight: FontWeight.w400),
        Gap(10),

        Row(
          children: [
            CustomText(
              text: 'EMI  Available ',
              size: 16,
              weight: FontWeight.w400,
            ),
            Gap(10),
            CustomText(
              text: 'Details',
              size: 13,
              weight: FontWeight.w500,
              color: AppColors.redColor,
            ),
            Spacer(),
            SizedBox.shrink(),
          ],
        ),
      ],
    );
  }
}
