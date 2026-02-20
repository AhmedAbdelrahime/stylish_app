import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/pages/settings/view/add_pyment_card.dart';
import 'package:hungry/shared/custom_text.dart';

class AddCardButton extends StatelessWidget {
  const AddCardButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AddPaymentCard()),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: AppColors.grayColor.withOpacity(.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomText(
              text: 'Add Card',
              size: 18,
              weight: FontWeight.w600,
              color: AppColors.blackColor.withOpacity(.8),
            ),
            Gap(10),
            Icon(
              Icons.payment_outlined,
              color: AppColors.blackColor.withOpacity(.8),
            ),
          ],
        ),
      ),
    );
  }
}
