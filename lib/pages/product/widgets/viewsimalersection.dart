import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hungry/shared/custom_text.dart';

class ViewSimalerSection extends StatelessWidget {
  const ViewSimalerSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(10, 8, 40, 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(Icons.visibility_outlined, size: 24),
                    Gap(10),
                    CustomText(
                      text: 'View Similar',
                      size: 14,
                      weight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10, 8, 15, 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(Icons.compare_arrows_outlined, size: 24),
                    Gap(10),
                    CustomText(
                      text: 'Add to Compare',
                      size: 14,
                      weight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
            ],
          ),
          CustomText(text: 'Similar To', size: 22, weight: FontWeight.bold),
        ],
      ),
    );
  }
}