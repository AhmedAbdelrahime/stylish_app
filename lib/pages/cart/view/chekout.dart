import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/pages/cart/widgets/cutom_oreder_text.dart';
import 'package:hungry/pages/cart/widgets/success_dialog.dart';
import 'package:hungry/pages/product/widgets/product_app_bar.dart';
import 'package:hungry/pages/settings/widgets/payment_details.dart';
import 'package:hungry/shared/custom_button.dart';
import 'package:hungry/shared/custom_text.dart';

class ChekoutPage extends StatelessWidget {
  const ChekoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProductAppBar(text: 'Checkout', padiing: 0),
            Gap(20),
            CustomOrederText(
              text: 'Order',
              price: '7,000',
              color: AppColors.grayColor,
            ),
            Gap(20),
            CustomOrederText(
              text: 'Shipping',
              price: '30',
              color: AppColors.grayColor,
            ),
            Gap(20),
            CustomOrederText(
              text: 'Total',
              price: '7,030',
              color: AppColors.blackColor,
            ),
            Gap(10),
            Divider(color: Colors.grey.withOpacity(0.5)),
            Gap(10),
            CustomText(text: 'Payment', size: 18, weight: FontWeight.w600),
            Gap(10),
            PymentsDetails(chekeout: true),
            Gap(20),
            CustomButton(
              ontap: () {
                showDialog(
                  context: context,
                  builder: (context) => SuccessDialog(),
                );
              },
              text: 'Continue',
            ),
          ],
        ),
      ),
    );
  }
}
