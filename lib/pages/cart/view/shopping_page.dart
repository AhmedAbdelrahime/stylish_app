import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/pages/cart/widgets/custom_btn_sheet.dart';
import 'package:hungry/pages/cart/widgets/detlissection.dart';
import 'package:hungry/pages/cart/widgets/pay_section.dart';
import 'package:hungry/pages/product/widgets/product_app_bar.dart';

class ShoppingPage extends StatefulWidget {
  const ShoppingPage({super.key});

  @override
  State<ShoppingPage> createState() => _ShoppingPageState();
}

List<int> sizes = [8, 9, 10, 11, 12];
int selectedSize = 10;
List<int> qty = [1, 2, 3, 4, 5];
int selectedQty = 1;

class _ShoppingPageState extends State<ShoppingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProductAppBar(text: 'Shopping page', padiing: 0),
            Gap(20),

            DetailesSection(),
            Gap(20),
            PaySection(),
          ],
        ),
      ),
      bottomSheet: CustomBtnSheet(),
    );
  }
}
