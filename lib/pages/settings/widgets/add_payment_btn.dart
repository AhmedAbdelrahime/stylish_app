import 'package:flutter/material.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/l10n/app_localizations.dart';

class AddPaymentBtn extends StatelessWidget {
  const AddPaymentBtn({super.key, required this.onValidate});
  final VoidCallback onValidate;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onValidate,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[AppColors.primaryColor, AppColors.redColor],
            begin: Alignment(-1, -4),
            end: Alignment(1, 4),
          ),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        child: Text(
          context.tr('Save Card'),
          style: const TextStyle(
            color: Colors.black,
            fontFamily: 'halter',
            fontSize: 14,
            package: 'flutter_credit_card',
          ),
        ),
      ),
    );
  }
}
