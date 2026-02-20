
import 'package:flutter/material.dart';
import 'package:hungry/pages/cart/widgets/cart_btn.dart';
import 'package:hungry/shared/custom_text.dart';

class CustomBtnSheet extends StatelessWidget {
  const CustomBtnSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade600,
            blurRadius: 20,
            offset: Offset(0, 0),
          ),
        ],
      ),
      height: 110,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: '\$541',
                  color: Colors.black,
                  weight: FontWeight.bold,
                  size: 24,
                ),
                CustomText(
                  text: 'View Details',
                  color: Colors.red,
                  weight: FontWeight.w500,
                  size: 13,
                ),
              ],
            ),
            Spacer(),
            // isLoading
            //     ? Center(
            //         child: CupertinoActivityIndicator(
            //           radius: 20,
            //           color: AppColors.primaryColor,
            //         ),
            //       )
            //     :
            CartBtn(ontap: () {}, text: 'Proceed to Payment'),
          ],
        ),
      ),
    );
  }
}
