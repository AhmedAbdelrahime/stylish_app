import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/pages/product/view/product_page.dart';
import 'package:hungry/shared/custom_text.dart';

class CardItem extends StatelessWidget {
  const CardItem({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProductPage()),
        );
      },
      child: Container(
        clipBehavior: Clip.antiAlias,
        width: 150,
        height: 160,
        margin: EdgeInsets.all(8),

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Image.asset(
              'assets/images/cat.png',
              width: double.infinity,
              height: 115,
              fit: BoxFit.fill,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  CustomText(
                    text: 'Women Printed Kurta',
                    size: 12,
                    weight: FontWeight.w500,
                  ),
                  CustomText(
                    text: 'Neque porro quisquam est qui dolorem ipsum quia',
                    size: 10,
                    weight: FontWeight.w500,
                    color: AppColors.grayColor,
                  ),

                  CustomText(
                    text: '₹1500',
                    size: 14,
                    weight: FontWeight.w500,
                    color: AppColors.blackColor,
                  ),
                  RatingBar.builder(
                    initialRating: 3.5,
                    minRating: 1,
                    allowHalfRating: true,

                    itemSize: 15,
                    itemPadding: EdgeInsetsGeometry.all(2),
                    itemBuilder: (context, index) =>
                        Icon(Icons.star, color: Colors.amber),
                    // ignore: avoid_print
                    onRatingUpdate: (value) => print(value),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
