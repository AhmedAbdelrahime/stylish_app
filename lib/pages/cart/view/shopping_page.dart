import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hungry/core/auth/auth_navigation.dart';
import 'package:hungry/core/config/store_config.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/l10n/app_localizations.dart';
import 'package:hungry/pages/cart/data/coupon_service.dart';
import 'package:hungry/pages/cart/view/chekout.dart';
import 'package:hungry/pages/cart/widgets/custom_btn_sheet.dart';
import 'package:hungry/pages/cart/widgets/detlissection.dart';
import 'package:hungry/pages/cart/widgets/pay_section.dart';
import 'package:hungry/pages/home/models/product_model.dart';
import 'package:hungry/pages/product/widgets/product_app_bar.dart';

class ShoppingPage extends StatefulWidget {
  const ShoppingPage({
    super.key,
    required this.product,
    this.initialSelectedSize,
  });

  final ProductModel product;
  final String? initialSelectedSize;

  @override
  State<ShoppingPage> createState() => _ShoppingPageState();
}

class _ShoppingPageState extends State<ShoppingPage> {
  final CouponService _couponService = CouponService();
  final TextEditingController _couponController = TextEditingController();
  late String? _selectedSize;
  int _selectedQty = 1;
  AppliedCoupon? _appliedCoupon;
  String? _couponMessage;
  bool _isApplyingCoupon = false;

  @override
  void initState() {
    super.initState();
    _selectedSize = widget.product.availableSizes.isNotEmpty
        ? (widget.initialSelectedSize ?? widget.product.availableSizes.first)
        : null;
  }

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  double get _subtotal => widget.product.effectivePrice * _selectedQty;
  double get _shippingFee => StoreConfig.standardDeliveryFee;
  double get _discountAmount => _appliedCoupon?.discountAmount ?? 0.0;
  double get _total => _subtotal + _shippingFee - _discountAmount;

  Future<void> _applyCoupon() async {
    if (_isApplyingCoupon) return;

    final authenticated = await AuthNavigation.requireAuth(
      context,
      title: 'Sign in to use coupons',
      message:
          'Coupons are saved to your order, so sign in before applying a discount.',
    );
    if (!mounted || !authenticated) return;

    setState(() {
      _isApplyingCoupon = true;
      _couponMessage = null;
    });

    try {
      final coupon = await _couponService.validateCoupon(
        code: _couponController.text,
        subtotal: _subtotal,
      );

      if (!mounted) return;

      setState(() {
        _appliedCoupon = coupon;
        _couponController.text = coupon.code;
        _couponMessage = context.tr(
          coupon.description ?? 'Coupon applied successfully',
        );
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _appliedCoupon = null;
        _couponMessage = _couponErrorMessage(e);
      });
    } finally {
      if (mounted) {
        setState(() {
          _isApplyingCoupon = false;
        });
      }
    }
  }

  void _removeCoupon() {
    setState(() {
      _appliedCoupon = null;
      _couponController.clear();
      _couponMessage = null;
    });
  }

  String _couponErrorMessage(Object error) {
    if (error is CouponException) {
      return context.tr(error.messageKey, error.values);
    }

    return context.tr(error.toString().replaceFirst('Exception: ', ''));
  }

  Future<void> _openCheckout() async {
    final authenticated = await AuthNavigation.requireAuth(
      context,
      title: 'Sign in to checkout',
      message:
          'You can prepare your order as a guest. Sign in now to save delivery details and place the order.',
    );
    if (!mounted || !authenticated) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChekoutPage(
          product: widget.product,
          selectedSize: _selectedSize,
          quantity: _selectedQty,
          appliedCoupon: _appliedCoupon,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ProductAppBar(text: 'Shopping Bag', padiing: 0),
            const Gap(20),
            DetailesSection(
              product: widget.product,
              selectedSize: _selectedSize,
              quantity: _selectedQty,
              onSizeChanged: (size) {
                setState(() {
                  _selectedSize = size;
                });
              },
              onQuantityChanged: (qty) {
                setState(() {
                  _selectedQty = qty;
                  _couponMessage = null;
                  _appliedCoupon = null;
                });
              },
            ),
            const Gap(20),
            PaySection(
              subtotal: _subtotal,
              shippingFee: _shippingFee,
              discountAmount: _discountAmount,
              couponController: _couponController,
              couponMessage: _couponMessage,
              appliedCouponCode: _appliedCoupon?.code,
              isApplyingCoupon: _isApplyingCoupon,
              onApplyCoupon: _applyCoupon,
              onRemoveCoupon: _removeCoupon,
              total: _total,
            ),
          ],
        ),
      ),
      bottomSheet: CustomBtnSheet(
        total: _total,
        discountAmount: _discountAmount,
        onProceed: _openCheckout,
      ),
    );
  }
}
