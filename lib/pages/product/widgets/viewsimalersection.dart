import 'package:flutter/material.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/l10n/app_localizations.dart';

class ViewSimalerSection extends StatelessWidget {
  const ViewSimalerSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.tr('Similar To This'),
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.blackColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            context.tr('Related picks based on the current product category.'),
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.hintColor,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
