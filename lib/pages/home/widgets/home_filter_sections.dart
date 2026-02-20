import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:hungry/shared/custom_text.dart';

class HomeFilterSection extends StatelessWidget {
  const HomeFilterSection({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          CustomText(text: text, size: 18, weight: FontWeight.w700),
          Spacer(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              children: [
                CustomText(text: 'Sort', size: 14, weight: FontWeight.w400),
                Gap(10),
                SvgPicture.asset('assets/svgs/sort.svg'),
              ],
            ),
          ),
          Gap(10),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              children: [
                CustomText(text: 'Filter', size: 14, weight: FontWeight.w400),
                Gap(10),
                SvgPicture.asset('assets/svgs/filter.svg'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
