import 'package:flutter/material.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/l10n/app_localizations.dart';

class CustomText extends StatelessWidget {
  const CustomText({
    super.key,
    required this.text,
    required this.size,
    required this.weight,
    this.color = AppColors.blackColor,
    this.decoration,
  });

  final String text;
  final double size;
  final FontWeight weight;
  final Color? color;
  final TextDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    return Text(
      context.tr(text),
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: size,
        fontWeight: weight,
        color: color,
        decoration: decoration,
        decorationColor: AppColors.grayColor,
        decorationThickness: 1.2,
        letterSpacing: 0,
      ),
    );
  }
}
