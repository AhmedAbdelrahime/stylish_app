import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gap/gap.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/pages/product/model/product_model.dart';
import 'package:hungry/pages/product/widgets/policy_widget.dart';
import 'package:hungry/shared/custom_text.dart';

class ProductDesc extends StatelessWidget {
  const ProductDesc({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(text: items[0].name, size: 20, weight: FontWeight.w600),
          CustomText(
            text: items[0].title,
            size: 14,
            weight: FontWeight.w500,
            color: AppColors.hintColor,
          ),
          Gap(5),
          Row(
            children: [
              RatingBar.builder(
                initialRating: items[0].rat,
                minRating: 1,
                allowHalfRating: true,

                itemSize: 15,
                itemPadding: EdgeInsetsGeometry.all(2),
                itemBuilder: (context, index) =>
                    Icon(Icons.star, color: Colors.amber),
                // ignore: avoid_print
                onRatingUpdate: (value) => print(value),
              ),
              Gap(10),

              CustomText(
                text: '₹${items[0].price}',
                size: 14,
                weight: FontWeight.w500,
                color: AppColors.blackColor,
              ),
            ],
          ),
          CustomText(
            text: 'Product Details',
            size: 16,
            weight: FontWeight.w600,
          ),
          Text(items[0].des),
          Gap(10),
          PolicyWidget(),
        ],
      ),
    );
  }
}
