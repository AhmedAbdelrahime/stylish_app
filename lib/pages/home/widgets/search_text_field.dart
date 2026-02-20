
import 'package:flutter/material.dart';
import 'package:hungry/core/constants/app_colors.dart';

class SearchTextField extends StatelessWidget {
  const SearchTextField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(10),
        child: TextField(
          cursorColor: Colors.grey,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search, color: AppColors.grayColor),
            suffixIcon: Icon(
              Icons.keyboard_voice_outlined,
              color: AppColors.grayColor,
            ),
            hintText: 'Search any Product',
            hintStyle: TextStyle(color: AppColors.grayColor),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.transparent),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.transparent),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.transparent),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.transparent),
            ),
          ),
        ),
      ),
    );
  }
}
