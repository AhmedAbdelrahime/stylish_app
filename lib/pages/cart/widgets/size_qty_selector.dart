import 'package:flutter/material.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/shared/custom_text.dart';

class SizeQtySelector<T> extends StatelessWidget {
  const SizeQtySelector({
    super.key,
    required this.values,
    required this.selectedValue,
    required this.text,
    required this.onChanged,
  });

  final List<T> values;
  final T selectedValue;
  final String text;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: 34,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          CustomText(text: '$text:', size: 14, weight: FontWeight.w400),
          DropdownButton<T>(
            dropdownColor: Colors.white,
            icon: const Icon(
              Icons.keyboard_arrow_down_outlined,
              color: AppColors.blackColor,
            ),
            underline: const SizedBox(),
            value: selectedValue,
            items: values.map((value) {
              return DropdownMenuItem<T>(
                value: value,
                child: CustomText(
                  text: value.toString(),
                  size: 14,
                  weight: FontWeight.w500,
                ),
              );
            }).toList(),
            onChanged: (newValue) {
              if (newValue != null) {
                onChanged(newValue);
              }
            },
          ),
        ],
      ),
    );
  }
}
