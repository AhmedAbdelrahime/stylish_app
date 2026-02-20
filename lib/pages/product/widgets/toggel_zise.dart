import 'package:flutter/material.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/pages/product/model/product_model.dart';
import 'package:hungry/shared/custom_text.dart';

class ToggelSize extends StatefulWidget {
  const ToggelSize({super.key});

  @override
  State<ToggelSize> createState() => _ToggelSizeState();
}

class _ToggelSizeState extends State<ToggelSize> {
  int selctedInedx = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: 'Size: ${sizeproduct[selctedInedx]}UK',
            size: 14,
            weight: FontWeight.w600,
          ),
          Row(
            children: List.generate(
              sizeproduct.length,
              (index) => GestureDetector(
                onTap: () {
                  setState(() {
                    selctedInedx = index;
                  });
                },
                child: Container(
                  margin: EdgeInsets.only(top: 10, bottom: 10, right: 10),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: selctedInedx == index
                        ? Colors.pink.shade300
                        : AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(width: 2, color: Colors.pink.shade300),
                  ),
                  child: CustomText(
                    text: '${sizeproduct[index]}UK',
                    size: 14,
                    weight: FontWeight.w600,
                    color: selctedInedx == index
                        ? AppColors.primaryColor
                        : Colors.pink.shade300,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
