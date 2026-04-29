import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/shared/custom_text.dart';

class SuccessDialog extends StatelessWidget {
  const SuccessDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),

          color: AppColors.primaryColor,
        ),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),

        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset('assets/svgs/success.svg'),
            Gap(10),
            Center(
              child: CustomText(
<<<<<<< HEAD
                text: 'Order placed successfully.',
=======
                text: 'Payment done successfully.',
>>>>>>> 71e363e9e57e6f331681c6680a26430d8356d3c8
                color: Colors.black,
                weight: FontWeight.w500,
                size: 16,
              ),
            ),
            Gap(20),
<<<<<<< HEAD
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context, false),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.blackColor,
                      side: const BorderSide(color: AppColors.blackColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Done'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.redColor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Track Order'),
                  ),
                ),
              ],
            ),
=======
            // CartBtn(
            //   width: double.infinity,
            //   ontap: () => Navigator.pop(context),
            //   text: 'Go Back',
            // ),
>>>>>>> 71e363e9e57e6f331681c6680a26430d8356d3c8
          ],
        ),
      ),
    );
  }
}
