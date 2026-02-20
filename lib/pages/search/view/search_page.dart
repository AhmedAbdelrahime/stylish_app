import 'package:flutter/material.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/pages/home/widgets/card_item.dart';
import 'package:hungry/pages/home/widgets/home_app_bar.dart';
import 'package:hungry/pages/home/widgets/home_filter_sections.dart';
import 'package:hungry/pages/home/widgets/search_text_field.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.primaryColor,

        body: Column(
          children: [
            HomeAppBar(),
            SearchTextField(),
            HomeFilterSection(text: '52,082+ Iteams'),
            Expanded(
              child: GridView.builder(
                // clipBehavior: Clip.antiAlias,
                itemCount: 10,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: .9,
                ),

                itemBuilder: (context, index) => CardItem(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
