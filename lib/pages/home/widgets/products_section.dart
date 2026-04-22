import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/pages/home/logic/product/cubit/product_cubit.dart';
import 'package:hungry/pages/home/logic/product/cubit/product_state.dart';
import 'package:hungry/pages/home/models/product_model.dart';
import 'package:hungry/pages/home/view/section_products_page.dart';
import 'package:hungry/pages/home/widgets/card_item.dart';

enum ProductSectionMode { latest, highestRated, lowestPrice }

class ProudectsSection extends StatelessWidget {
  const ProudectsSection({
    super.key,
    this.products,
    this.title = 'Products',
    this.subtitle,
    this.excludeProductId,
    this.maxItems,
    this.mode = ProductSectionMode.latest,
  });

  final List<ProductModel>? products;
  final String title;
  final String? subtitle;
  final String? excludeProductId;
  final int? maxItems;
  final ProductSectionMode mode;

  @override
  Widget build(BuildContext context) {
    if (products != null) {
      return _ProductsList(
        products: products!,
        title: title,
        subtitle: subtitle,
        excludeProductId: excludeProductId,
        maxItems: maxItems,
        mode: mode,
      );
    }

    return BlocBuilder<ProductCubit, ProductState>(
      builder: (context, state) {
        if (state is ProductLoading) {
          return const SizedBox(
            height: 292,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is ProductError) {
          return SizedBox(
            height: 292,
            child: Center(
              child: Text(state.message, textAlign: TextAlign.center),
            ),
          );
        }

        if (state is ProductLoaded) {
          return _ProductsList(
            products: state.products,
            title: title,
            subtitle: subtitle,
            excludeProductId: excludeProductId,
            maxItems: maxItems,
            mode: mode,
          );
        }

        return const SizedBox(
          height: 292,
          child: Center(child: Text('Loading products...')),
        );
      },
    );
  }
}

class _ProductsList extends StatelessWidget {
  const _ProductsList({
    required this.products,
    required this.title,
    required this.subtitle,
    required this.excludeProductId,
    required this.maxItems,
    required this.mode,
  });

  final List<ProductModel> products;
  final String title;
  final String? subtitle;
  final String? excludeProductId;
  final int? maxItems;
  final ProductSectionMode mode;

  @override
  Widget build(BuildContext context) {
    final filteredProducts = products
        .where((product) => product.id != excludeProductId)
        .toList();

    switch (mode) {
      case ProductSectionMode.highestRated:
        filteredProducts.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case ProductSectionMode.lowestPrice:
        filteredProducts.sort((a, b) => a.price.compareTo(b.price));
        break;
      case ProductSectionMode.latest:
        break;
    }

    final displayedProducts = maxItems == null
        ? filteredProducts
        : filteredProducts.take(maxItems!).toList();

    if (displayedProducts.isEmpty) {
      return const SizedBox(
        height: 292,
        child: Center(child: Text('No products found')),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: AppColors.blackColor,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        subtitle!,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.hintColor,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 12),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SectionProductsPage(
                        title: title,
                        subtitle: subtitle,
                        products: filteredProducts,
                      ),
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.redColor,
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'See all',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 292,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: displayedProducts.length,
            itemBuilder: (context, index) => CardItem(
              product: displayedProducts[index],
              relatedProducts: filteredProducts,
            ),
          ),
        ),
      ],
    );
  }
}
