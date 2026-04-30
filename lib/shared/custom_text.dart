import 'package:flutter/material.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/l10n/app_localizations.dart';

class CustomText extends StatelessWidget {
  const CustomText({
    super.key,
    this.decoration,
    required this.text,
    required this.size,
    required this.weight,
    this.color = AppColors.blackColor,
  });
  final String text;
  final double size;
  final FontWeight weight;
  final Color? color;
  final TextDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    final localizedText = context.tr(text);

    return Text(
      localizedText,

      style: TextStyle(
        fontSize: size,
        fontWeight: weight,
        color: color,
        decorationColor: AppColors.grayColor,
        decorationThickness: 1.2,

        decoration: decoration, // 👈 strike-through
        // overflow: TextOverflow.ellipsis,
        letterSpacing: 0,
        // fontFamily: GoogleFonts.montserrat().fontFamily,
      ),

      textAlign: TextAlign.center,
    );
  }
}
