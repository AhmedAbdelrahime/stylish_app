import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gap/gap.dart';
import 'package:hungry/core/config/store_config.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/l10n/app_localizations.dart';
import 'package:hungry/pages/home/models/product_model.dart';
import 'package:hungry/pages/product/widgets/policy_widget.dart';
import 'package:hungry/shared/custom_text.dart';

class ProductDesc extends StatelessWidget {
  const ProductDesc({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final stockLabel = !StoreConfig.enforceStockQuantity
        ? context.tr('In stock')
        : product.isInStock
        ? (product.isLowStock
              ? context.tr('Only {count} left', {
                  'count': product.stockQuantity,
                })
              : context.tr('In stock ({count} available)', {
                  'count': product.stockQuantity,
                }))
        : context.tr('Out of stock');

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(text: product.name, size: 20, weight: FontWeight.w600),
          CustomText(
            text: product.title,
            size: 14,
            weight: FontWeight.w500,
            color: AppColors.hintColor,
          ),
          const Gap(8),
          Row(
            children: [
              RatingBarIndicator(
                rating: product.rating.clamp(0, 5).toDouble(),
                itemBuilder: (context, index) =>
                    const Icon(Icons.star_rounded, color: Colors.amber),
                itemCount: 5,
                itemSize: 18,
              ),
              const Gap(8),
              Text(
                product.rating.toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.hintColor,
                ),
              ),
              const Spacer(),
              CustomText(
                text: AppPrice.format(product.effectivePrice),
                size: 18,
                weight: FontWeight.w700,
                color: AppColors.blackColor,
              ),
            ],
          ),
          const Gap(12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: product.isInStock
                      ? (product.isLowStock
                            ? AppColors.redColor.withValues(alpha: 0.1)
                            : const Color(0xFFE8F7ED))
                      : const Color(0xFFE8F7ED),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  stockLabel,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: product.isInStock
                        ? (product.isLowStock
                              ? AppColors.redColor
                              : const Color(0xFF1E8E5A))
                        : AppColors.redColor,
                  ),
                ),
              ),
              if (product.featured)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE7F0FF),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    context.tr('Featured Product'),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2558C5),
                    ),
                  ),
                ),
              if (product.hasSale)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF2D9),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    context.tr('Sale {price}', {
                      'price': AppPrice.format(product.salePrice!),
                    }),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFB7791F),
                    ),
                  ),
                ),
            ],
          ),
          const Gap(14),
          if (product.sku?.isNotEmpty == true) ...[
            Text(
              context.tr('SKU: {sku}', {'sku': product.sku}),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.hintColor,
              ),
            ),
            const Gap(10),
          ],
          const CustomText(
            text: 'Product Details',
            size: 16,
            weight: FontWeight.w600,
          ),
          const Gap(6),
          Text(
            product.description,
            style: const TextStyle(color: AppColors.hintColor, height: 1.5),
          ),
          const Gap(12),
          const PolicyWidget(),
        ],
      ),
    );
  }
}
