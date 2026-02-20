import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gap/gap.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/shared/custom_text.dart';

class ShppingCard extends StatefulWidget {
  const ShppingCard({super.key});

  @override
  State<ShppingCard> createState() => _ShppingCardState();
}

class _ShppingCardState extends State<ShppingCard> {
  double _rating = 3.5; // 👈 initial ratin   g
  @override
  Widget build(BuildContext context) {
    return    Card(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
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
                              size: 14,
                              weight: FontWeight.w500,
                            ),
                            Gap(5),
                            Row(
                              children: [
                                CustomText(
                                  text: 'Variations : ',
                                  size: 14,
                                  weight: FontWeight.w400,
                                  color: AppColors.blackColor,
                                ),
                                Gap(10),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                      color: AppColors.blackColor,
                                    ),
                                  ),
                                  child: CustomText(
                                    text: 'Black',
                                    size: 12,
                                    weight: FontWeight.w400,
                                    color: AppColors.blackColor,
                                  ),
                                ),
                                Gap(8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                      color: AppColors.blackColor,
                                    ),
                                  ),
                                  child: CustomText(
                                    text: 'Red',
                                    size: 12,
                                    weight: FontWeight.w400,
                                    color: AppColors.blackColor,
                                  ),
                                ),
                              ],
                            ),

                            Row(
                              children: [
                                CustomText(
                                  text: _rating.toString(),
                                  size: 14,
                                  weight: FontWeight.w400,
                                  color: AppColors.blackColor,
                                ),
                                Gap(5),
                                RatingBar.builder(
                                  initialRating: 3.5,
                                  minRating: 1,
                                  allowHalfRating: true,

                                  itemSize: 15,
                                  itemPadding: EdgeInsetsGeometry.all(2),
                                  itemBuilder: (context, index) =>
                                      Icon(Icons.star, color: Colors.amber),
                                  // ignore: avoid_print
                                  onRatingUpdate: (value) => setState(() {
                                    _rating = value;
                                  }),
                                ),
                              ],
                            ),
                            Gap(5),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                      color: AppColors.grayColor,
                                    ),
                                  ),
                                  child: CustomText(
                                    text: '\$ 34.00',
                                    size: 18,
                                    weight: FontWeight.w600,
                                    color: AppColors.blackColor,
                                  ),
                                ),
                                Gap(20),
                                Column(
                                  children: [
                                    CustomText(
                                      text: 'upto 33% off  ',
                                      size: 12,
                                      weight: FontWeight.w400,
                                      color: AppColors.redColor,
                                    ),
                                    CustomText(
                                      text: '\$ 64.00',
                                      size: 14,
                                      weight: FontWeight.w400,
                                      color: AppColors.grayColor,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Gap(10),
                          ],
                        ),
                      ],
                    ),
                    Divider(color: Colors.grey.withOpacity(0.5)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          text: 'Total Order (1)   :',
                          size: 16,
                          weight: FontWeight.w400,
                          color: AppColors.blackColor,
                        ),
                        CustomText(
                          text: '\$ 34.00',
                          size: 16,
                          weight: FontWeight.w600,
                          color: AppColors.blackColor,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
  }
}