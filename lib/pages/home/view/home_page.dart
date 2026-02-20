import 'package:flutter/material.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/pages/home/widgets/cat_section.dart';
import 'package:hungry/pages/home/widgets/home_app_bar.dart';
import 'package:hungry/pages/home/widgets/home_filter_sections.dart';
import 'package:hungry/pages/home/widgets/offers_section.dart';
import 'package:hungry/pages/home/widgets/products_section.dart';
import 'package:hungry/pages/home/widgets/search_text_field.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // final ProfileService _profileService = ProfileService();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.primaryColor,
        body: Skeletonizer(
          enabled: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HomeAppBar(),
              SearchTextField(),
              HomeFilterSection(text: 'All Featured'),
              CatSection(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      OffersSection(),
                      Column(
                        children: List.generate(
                          5,
                          (index) => ProudectsSection(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
