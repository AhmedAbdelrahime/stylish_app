import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/pages/home/widgets/home_filter_sections.dart';
import 'package:hungry/pages/home/widgets/products_section.dart';
import 'package:hungry/pages/product/widgets/Product_desc.dart';
import 'package:hungry/pages/product/widgets/dilaverywidget.dart';
import 'package:hungry/pages/product/widgets/product_app_bar.dart';
import 'package:hungry/pages/product/widgets/productbutton.dart';
import 'package:hungry/pages/product/widgets/proudect_images.dart';
import 'package:hungry/pages/product/widgets/toggel_zise.dart';
import 'package:hungry/pages/product/widgets/viewsimalersection.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,

      // appBar: AppBar(title: const Text('Product Page')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ProductAppBar(),
            ProudectImages(),
            ToggelSize(),
            ProductDesc(),
            ProductBotton(),
            DelevaryWidget(),
            ViewSimalerSection(),

            HomeFilterSection(text: '52,082+ Iteams'),
            ProudectsSection(),

            Gap(50),
          ],
        ),
      ),
    );
  }
}
