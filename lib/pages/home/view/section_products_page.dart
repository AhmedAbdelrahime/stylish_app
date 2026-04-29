import 'package:flutter/material.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/pages/home/models/product_model.dart';
import 'package:hungry/pages/home/widgets/card_item.dart';

class SectionProductsPage extends StatelessWidget {
  const SectionProductsPage({
    super.key,
    required this.title,
    required this.products,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final List<ProductModel> products;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        titleSpacing: 20,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.blackColor,
              ),
            ),
            if (subtitle != null)
              Text(
                subtitle!,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.hintColor,
                ),
              ),
          ],
        ),
      ),
      body: products.isEmpty
          ? const Center(child: Text('No products found'))
          : GridView.builder(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              itemCount: products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.58,
              ),
              itemBuilder: (context, index) => CardItem(
                product: products[index],
                relatedProducts: products,
                margin: EdgeInsets.zero,
              ),
            ),
    );
  }
}
