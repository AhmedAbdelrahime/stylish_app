import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/pages/cart/widgets/address_section.dart';
import 'package:hungry/pages/cart/widgets/shpping_card.dart';
import 'package:hungry/pages/product/widgets/product_app_bar.dart';
import 'package:hungry/shared/custom_text.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  // final double _rating = 3.5; // 👈 initial rating

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProductAppBar(text: 'Cart', padiing: 0),
            Divider(color: Colors.grey.withOpacity(0.5)),
            Gap(10),
            AddressSection(),
            Gap(20),
            CustomText(
              text: 'Shopping List',
              size: 16,
              weight: FontWeight.w600,
            ),
            Gap(5),
            Expanded(
              child: ListView.builder(
                itemCount: 4,
                itemBuilder: (context, index) {
                  return const ShppingCard();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
