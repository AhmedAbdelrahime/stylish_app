import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/l10n/app_localizations.dart';
import 'package:hungry/pages/cart/data/cart_service.dart';
import 'package:hungry/pages/cart/view/chekout.dart';
import 'package:hungry/pages/cart/view/cart_page.dart';
import 'package:hungry/pages/home/models/product_model.dart';
import 'package:hungry/pages/home/widgets/products_section.dart';
import 'package:hungry/pages/product/widgets/product_desc.dart';
import 'package:hungry/pages/product/widgets/dilaverywidget.dart';
import 'package:hungry/pages/product/widgets/product_app_bar.dart';
import 'package:hungry/pages/product/widgets/productbutton.dart';
import 'package:hungry/pages/product/widgets/proudect_images.dart';
import 'package:hungry/pages/product/widgets/review_section.dart';
import 'package:hungry/pages/product/widgets/toggel_zise.dart';
import 'package:hungry/pages/product/widgets/viewsimalersection.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({
    super.key,
    required this.product,
    required this.relatedProducts,
  });

  final ProductModel product;
  final List<ProductModel> relatedProducts;

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final CartService _cartService = CartService();
  String? _selectedSize;
  bool _isAddingToCart = false;

  @override
  void initState() {
    super.initState();
    if (widget.product.availableSizes.isNotEmpty) {
      _selectedSize = widget.product.availableSizes.first;
    }
  }

  List<ProductModel> get _similarProducts {
    final sameCategory = widget.relatedProducts
        .where(
          (candidate) =>
              candidate.id != widget.product.id &&
              candidate.categoryId == widget.product.categoryId,
        )
        .toList();

    if (sameCategory.isNotEmpty) {
      return sameCategory;
    }

    return widget.relatedProducts
        .where((candidate) => candidate.id != widget.product.id)
        .toList();
  }

  Future<void> _addCurrentProductToCart() async {
    if (_isAddingToCart) return;

    setState(() {
      _isAddingToCart = true;
    });

    try {
      final quantity = await _cartService.addItem(
        product: widget.product,
        quantity: 1,
        selectedSize: _selectedSize,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            quantity > 1
                ? context.tr(
                    'Cart updated. You now have {count} of this item.',
                    {'count': quantity},
                  )
                : context.tr('Added to cart.'),
          ),
          action: SnackBarAction(
            label: context.tr('View Cart'),
            onPressed: _openCartPage,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.tr(e.toString().replaceFirst('Exception: ', '')),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isAddingToCart = false;
        });
      }
    }
  }

  void _openCartPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CartPage()),
    );
  }

  void _openCheckoutFlow() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChekoutPage(
          product: widget.product,
          selectedSize: _selectedSize,
          quantity: 1,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      bottomNavigationBar: ProductBotton(
        price: widget.product.effectivePrice,
        selectedSize: _selectedSize,
        onGoToCart: _isAddingToCart
            ? () {}
            : () {
                _addCurrentProductToCart();
              },
        onBuyNow: _openCheckoutFlow,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProductAppBar(onActionTap: _openCartPage),
              ProudectImages(product: widget.product),
              ToggelSize(
                product: widget.product,
                selectedSize: _selectedSize,
                onChanged: (size) {
                  setState(() {
                    _selectedSize = size;
                  });
                },
              ),
              ProductDesc(product: widget.product),
              ReviewSection(productId: widget.product.id),
              const DelevaryWidget(),
              const ViewSimalerSection(),
              if (_similarProducts.isNotEmpty) ...[
                ProudectsSection(
                  products: _similarProducts,
                  title: 'Similar Products',
                  subtitle: 'More picks from the same style direction.',
                  excludeProductId: widget.product.id,
                ),
                const Gap(120),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
