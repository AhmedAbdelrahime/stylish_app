import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hungry/core/config/store_config.dart';
import 'package:hungry/l10n/app_localizations.dart';
import 'package:hungry/pages/cart/widgets/size_qty_selector.dart';
import 'package:hungry/pages/home/models/product_model.dart';
import 'package:hungry/shared/custom_text.dart';

class DetailesSection extends StatelessWidget {
  const DetailesSection({
    super.key,
    required this.product,
    required this.selectedSize,
    required this.quantity,
    required this.onSizeChanged,
    required this.onQuantityChanged,
  });

  final ProductModel product;
  final String? selectedSize;
  final int quantity;
  final ValueChanged<String> onSizeChanged;
  final ValueChanged<int> onQuantityChanged;

  @override
  Widget build(BuildContext context) {
    final sizes = product.availableSizes;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 120,
          height: 160,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: NetworkImage(product.primaryImage),
              fit: BoxFit.cover,
              onError: (_, __) {},
            ),
          ),
          child: product.primaryImage.isEmpty
              ? const ColoredBox(color: Colors.white)
              : null,
        ),
        const Gap(10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(text: product.name, size: 16, weight: FontWeight.w500),
              const Gap(5),
              CustomText(
                text: product.title,
                size: 12,
                weight: FontWeight.w400,
              ),
              const Gap(10),
              Row(
                children: [
                  if (sizes.isNotEmpty) ...[
                    SizeQtySelector(
                      values: sizes,
                      selectedValue: selectedSize ?? sizes.first,
                      text: 'Size',
                      onChanged: onSizeChanged,
                    ),
                    const Gap(12),
                  ],
                  SizeQtySelector(
                    values: const [1, 2, 3, 4, 5],
                    selectedValue: quantity,
                    text: 'Qty',
                    onChanged: onQuantityChanged,
                  ),
                ],
              ),
              const Gap(20),
              Row(
                children: [
                  Text(
                    context.tr('Delivery by '),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    context.tr(StoreConfig.defaultDeliveryWindowLabel),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
