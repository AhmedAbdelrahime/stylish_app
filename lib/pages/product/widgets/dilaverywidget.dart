import 'package:flutter/material.dart';
import 'package:hungry/core/config/store_config.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/l10n/app_localizations.dart';

class DelevaryWidget extends StatelessWidget {
  const DelevaryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.grayColor.withValues(alpha: 0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.tr('Delivery'),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.blackColor,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              context.tr(
                'Standard delivery in {days}. Tracking details appear after checkout.',
                {'days': context.tr(StoreConfig.defaultDeliveryWindowLabel)},
              ),
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.hintColor,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
