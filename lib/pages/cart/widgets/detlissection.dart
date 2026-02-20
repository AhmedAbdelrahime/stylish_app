
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hungry/pages/cart/view/shopping_page.dart';
import 'package:hungry/pages/cart/widgets/size_qty_selector.dart';
import 'package:hungry/shared/custom_text.dart';

class DetailesSection extends StatelessWidget {
  const DetailesSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 120,
          height: 160,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: const DecorationImage(
              image: AssetImage('assets/images/cat.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Gap(10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CustomText(
              text: 'Women’s Casual Wear',
              size: 16,
              weight: FontWeight.w500,
            ),
            Gap(5),
    
            CustomText(
              text: 'Checked Single-Breasted Blazer',
              size: 12,
              weight: FontWeight.w400,
            ),
            Gap(5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizeQtySelector(
                  sizes: sizes,
                  selectedSize: selectedSize,
                  text: 'Size',
                ),
                Gap(20),
                SizeQtySelector(
                  sizes: qty,
                  selectedSize: selectedQty,
                  text: 'Qty',
                ),
              ],
            ),
            Gap(20),
            Row(
              children: [
                CustomText(
                  text: 'Delivery by ',
                  size: 14,
                  weight: FontWeight.w400,
                ),
                CustomText(
                  text: '10 May 2XXX',
                  size: 16,
                  weight: FontWeight.w600,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
