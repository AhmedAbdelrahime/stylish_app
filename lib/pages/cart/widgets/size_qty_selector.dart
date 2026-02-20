import 'package:flutter/material.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/shared/custom_text.dart';

class SizeQtySelector extends StatefulWidget {
  const SizeQtySelector({
    super.key,
    required this.sizes,
    required this.selectedSize,
    required this.text,
  });
  final List<int> sizes;
  final int selectedSize;
  final String text;
  @override
  State<SizeQtySelector> createState() => _SizeQtySelectorState();
}

class _SizeQtySelectorState extends State<SizeQtySelector> {
  late int selectedSize;
  @override
  void initState() {
    super.initState();
    selectedSize = widget.selectedSize;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: 30,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          CustomText(
            text: '${widget.text} :',
            size: 16,
            weight: FontWeight.w400,
          ),
          DropdownButton<int>(
            dropdownColor: Colors.white,
            icon: Icon(
              Icons.keyboard_arrow_down_outlined,
              color: AppColors.blackColor,
            ),
            underline: const SizedBox(),
            value: selectedSize,
            items: widget.sizes.map((int size) {
              return DropdownMenuItem<int>(
                value: size,
                child: CustomText(
                  text: size.toString(),
                  size: 15,
                  weight: FontWeight.w500,
                ),
              );
            }).toList(),
            onChanged: (int? newValue) {
              setState(() {
                selectedSize = newValue!;
              });
            },
          ),
        ],
      ),
    );
  }
}
