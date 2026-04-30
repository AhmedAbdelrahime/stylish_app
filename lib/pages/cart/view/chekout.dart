import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hungry/core/api/supabase_error_mapper.dart';
import 'package:hungry/core/auth/auth_navigation.dart';
import 'package:hungry/core/config/store_config.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/l10n/app_localizations.dart';
import 'package:hungry/pages/cart/data/coupon_service.dart';
import 'package:hungry/pages/cart/data/order_service.dart';
import 'package:hungry/pages/cart/data/whatsapp_order_service.dart';
import 'package:hungry/pages/cart/widgets/cash_on_delivery_tile.dart';
import 'package:hungry/pages/cart/widgets/contact_number_prompt.dart';
import 'package:hungry/pages/cart/widgets/success_dialog.dart';
import 'package:hungry/pages/home/models/product_model.dart';
import 'package:hungry/pages/orders/view/order_details_page.dart';
import 'package:hungry/pages/product/widgets/product_app_bar.dart';
import 'package:hungry/pages/settings/data/profile_service.dart';
import 'package:hungry/pages/settings/data/user_model.dart';
import 'package:hungry/pages/settings/view/settings_page.dart';

class ChekoutPage extends StatefulWidget {
  const ChekoutPage({
    super.key,
    required this.product,
    required this.quantity,
    this.selectedSize,
    this.appliedCoupon,
  });

  final ProductModel product;
  final int quantity;
  final String? selectedSize;
  final AppliedCoupon? appliedCoupon;

  @override
  State<ChekoutPage> createState() => _ChekoutPageState();
}

class _ChekoutPageState extends State<ChekoutPage> {
  static const double _shippingFee = StoreConfig.standardDeliveryFee;

  final OrderService _orderService = OrderService();
  final ProfileService _profileService = ProfileService();
  final CouponService _couponService = CouponService();
  final TextEditingController _couponController = TextEditingController();
  final WhatsAppOrderService _whatsAppOrderService =
      const WhatsAppOrderService();

  bool _isSubmitting = false;
  bool _isWhatsAppSubmitting = false;
  bool _isApplyingCoupon = false;
  bool _isLoadingDetails = true;
  AppliedCoupon? _appliedCoupon;
  String? _couponMessage;
  UserModel? _profile;

  @override
  void initState() {
    super.initState();
    _appliedCoupon = widget.appliedCoupon;
    if (_appliedCoupon != null) {
      _couponController.text = _appliedCoupon!.code;
    }
    _loadCheckoutDetails();
  }

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  Future<void> _loadCheckoutDetails() async {
    setState(() {
      _isLoadingDetails = true;
    });

    try {
      final profile = await _profileService.getProfile();

      if (!mounted) return;

      setState(() {
        _profile = profile;
        _isLoadingDetails = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoadingDetails = false;
      });
    }
  }

  double get _subtotal => widget.product.effectivePrice * widget.quantity;

  double get _discountAmount => _appliedCoupon?.discountAmount ?? 0.0;

  double get _total => _subtotal + _shippingFee - _discountAmount;

  String? get _shippingAddress {
    final parts =
        [
              _profile?.address,
              _profile?.city,
              _profile?.state,
              _profile?.country,
              _profile?.pincode,
            ]
            .whereType<String>()
            .map((value) => value.trim())
            .where((value) => value.isNotEmpty)
            .toList();

    if (parts.isEmpty) {
      return null;
    }

    return parts.join(', ');
  }

  String? get _contactPhone {
    final phone = _profile?.phone?.trim();
    if (phone == null || phone.isEmpty) {
      return null;
    }

    return phone;
  }

  String _deliveryDetailsText(BuildContext context) {
    final lines =
        [
              _shippingAddress,
              if (_contactPhone != null)
                context.tr('Phone: {phone}', {'phone': _contactPhone}),
              _profile?.email,
            ]
            .whereType<String>()
            .map((value) => value.trim())
            .where((value) => value.isNotEmpty)
            .toList();

    return lines.join('\n');
  }

  Future<void> _openAddressSettings() async {
    final authenticated = await AuthNavigation.requireAuth(
      context,
      title: 'Sign in to manage delivery',
      message:
          'Your delivery address is saved securely in your account and used only for checkout.',
    );
    if (!mounted || !authenticated) return;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const SettingsPage(showBackButton: true),
      ),
    );

    if (!mounted) return;
    await _loadCheckoutDetails();
  }

  Future<bool> _ensureContactPhone() async {
    if (_contactPhone != null) {
      return true;
    }

    final phone = await showContactNumberPrompt(
      context,
      initialPhone: _profile?.phone,
    );
    if (!mounted || phone == null) {
      return false;
    }

    final profile = _profile ?? await _profileService.getProfile();
    if (!mounted) return false;

    if (profile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.tr('Sign in again to save your number.')),
        ),
      );
      return false;
    }

    try {
      final updatedProfile = profile.copyWith(phone: phone);
      await _profileService.updateProfile(updatedProfile);

      if (!mounted) return false;
      setState(() {
        _profile = updatedProfile;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.tr('Contact number saved.'))),
      );
      return true;
    } catch (e) {
      if (!mounted) return false;

      final message = SupabaseErrorMapper.map(e.toString());
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.tr(message))));
      return false;
    }
  }

  Future<void> _applyCoupon() async {
    if (_isApplyingCoupon) return;

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

  Future<void> _submitOrder() async {
    if (_isSubmitting || _isWhatsAppSubmitting) return;

    final authenticated = await AuthNavigation.requireAuth(
      context,
      title: 'Sign in to place order',
      message:
          'Create an account or sign in so we can save your order and delivery details.',
    );
    if (!mounted || !authenticated) return;

    if (_profile == null) {
      await _loadCheckoutDetails();
      if (!mounted) return;
    }

    if (_shippingAddress == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.tr('Add your delivery address in Account first.'),
          ),
        ),
      );
      return;
    }

    final hasContactPhone = await _ensureContactPhone();
    if (!hasContactPhone) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      final orderId = await _orderService.createSingleItemOrder(
        product: widget.product,
        quantity: widget.quantity,
        selectedSize: widget.selectedSize,
        coupon: _appliedCoupon,
      );

      if (!mounted) return;

      final shouldTrackOrder = await showDialog<bool>(
        context: context,
        builder: (context) => const SuccessDialog(),
      );

      if (!mounted) return;

      if (shouldTrackOrder == true) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => OrderDetailsPage(orderId: orderId)),
        );
      } else {
        Navigator.pop(context);
      }
    } catch (e) {
      if (!mounted) return;

      final message = SupabaseErrorMapper.map(e.toString());
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.tr(message))));
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  Future<void> _submitWhatsAppOrder() async {
    if (_isSubmitting || _isWhatsAppSubmitting) return;

    final authenticated = await AuthNavigation.requireAuth(
      context,
      title: 'Sign in to place order',
      message:
          'Create an account or sign in so we can save your order and delivery details.',
    );
    if (!mounted || !authenticated) return;

    if (_profile == null) {
      await _loadCheckoutDetails();
      if (!mounted) return;
    }

    if (_shippingAddress == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.tr('Add your delivery address in Account first.'),
          ),
        ),
      );
      return;
    }

    final hasContactPhone = await _ensureContactPhone();
    if (!hasContactPhone) return;

    setState(() {
      _isWhatsAppSubmitting = true;
    });

    String? orderId;
    try {
      orderId = await _orderService.createSingleItemOrder(
        product: widget.product,
        quantity: widget.quantity,
        selectedSize: widget.selectedSize,
        coupon: _appliedCoupon,
        notes: StoreOrderMessages.whatsAppOrderNote,
      );

      await _whatsAppOrderService.openOrder(
        _buildWhatsAppRequest(orderId: orderId),
      );

      if (!mounted) return;

      final shouldTrackOrder = await showDialog<bool>(
        context: context,
        builder: (context) => const SuccessDialog(),
      );

      if (!mounted) return;

      if (shouldTrackOrder == true) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => OrderDetailsPage(orderId: orderId!),
          ),
        );
      } else {
        Navigator.pop(context);
      }
    } catch (e) {
      if (!mounted) return;

      final message = e is WhatsAppOrderException
          ? e.message
          : SupabaseErrorMapper.map(e.toString());
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.tr(message))));
    } finally {
      if (mounted) {
        setState(() {
          _isWhatsAppSubmitting = false;
        });
      }
    }
  }

  WhatsAppOrderRequest _buildWhatsAppRequest({required String orderId}) {
    return WhatsAppOrderRequest(
      orderId: orderId,
      lines: [
        WhatsAppOrderLine.fromProduct(
          product: widget.product,
          quantity: widget.quantity,
          selectedSize: widget.selectedSize,
        ),
      ],
      subtotal: _subtotal,
      shippingFee: _shippingFee,
      discountAmount: _discountAmount,
      totalAmount: _total,
      currency: StoreConfig.currencyCode,
      customerName: _profile?.name,
      customerEmail: _profile?.email,
      customerPhone: _contactPhone,
      shippingAddress: _shippingAddress,
      paymentLabel: StorePayment.cashOnDeliveryLabel,
      note: StoreOrderMessages.availabilityConfirmationNote,
    );
  }

  @override
  Widget build(BuildContext context) {
    final subtotal = _subtotal;
    final shipping = _shippingFee;
    final discountAmount = _discountAmount;
    final total = _total;
    final imageUrl = widget.product.primaryImage;
    final isBusy = _isSubmitting || _isWhatsAppSubmitting;

    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          context.tr('Total Payable'),
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.hintColor.withValues(alpha: 0.85),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Gap(4),
                        Text(
                          AppPrice.format(total),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: AppColors.blackColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Gap(12),
                  Expanded(
                    child: FilledButton(
                      onPressed: isBusy ? null : _submitOrder,
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.redColor,
                        disabledBackgroundColor: AppColors.redColor.withValues(
                          alpha: 0.6,
                        ),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: _isSubmitting
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              context.tr('Place Order'),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
              const Gap(10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: isBusy ? null : _submitWhatsAppOrder,
                  icon: _isWhatsAppSubmitting
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.chat_bubble_outline),
                  label: Text(
                    context.tr(
                      _isWhatsAppSubmitting
                          ? 'Opening WhatsApp...'
                          : 'Order on WhatsApp',
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF128C7E),
                    side: const BorderSide(color: Color(0xFF128C7E)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.redColor,
          onRefresh: _loadCheckoutDetails,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 190),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ProductAppBar(text: 'Checkout', padiing: 0),
                Text(
                  context.tr(
                    'Review your delivery details and payment before placing the order.',
                  ),
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: AppColors.hintColor.withValues(alpha: 0.95),
                  ),
                ),
                const Gap(20),
                if (_isLoadingDetails)
                  const LinearProgressIndicator(color: AppColors.redColor),
                if (_isLoadingDetails) const Gap(20),
                _CheckoutCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SectionHeader(
                        icon: Icons.location_on_outlined,
                        title: 'Delivery Address',
                        actionLabel: 'Manage',
                        onActionTap: _openAddressSettings,
                      ),
                      const Gap(14),
                      if (_shippingAddress == null)
                        _EmptyStateTile(
                          icon: Icons.home_work_outlined,
                          title: 'Address missing',
                          subtitle:
                              'Add your address in Account so we can deliver this order correctly.',
                          buttonLabel: 'Open Account',
                          onTap: _openAddressSettings,
                        )
                      else
                        _InfoTile(
                          title: (_profile?.name?.trim().isNotEmpty ?? false)
                              ? _profile!.name!.trim()
                              : context.tr('Delivery destination'),
                          subtitle: _deliveryDetailsText(context),
                        ),
                    ],
                  ),
                ),
                const Gap(16),
                _CheckoutCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      _SectionHeader(
                        icon: Icons.payments_outlined,
                        title: 'Payment Method',
                      ),
                      Gap(14),
                      CashOnDeliveryTile(),
                    ],
                  ),
                ),
                const Gap(16),
                _CheckoutCard(
                  child: _CouponBox(
                    controller: _couponController,
                    couponMessage: _couponMessage,
                    appliedCouponCode: _appliedCoupon?.code,
                    isApplyingCoupon: _isApplyingCoupon,
                    onApplyCoupon: _applyCoupon,
                    onRemoveCoupon: _removeCoupon,
                  ),
                ),
                const Gap(16),
                _CheckoutCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _SectionHeader(
                        icon: Icons.shopping_bag_outlined,
                        title: 'Order Summary',
                      ),
                      const Gap(16),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: imageUrl.isEmpty
                                ? Container(
                                    height: 88,
                                    width: 88,
                                    color: Colors.white,
                                    alignment: Alignment.center,
                                    child: Icon(
                                      Icons.image_not_supported_outlined,
                                      color: AppColors.hintColor.withValues(
                                        alpha: 0.75,
                                      ),
                                    ),
                                  )
                                : Image.network(
                                    imageUrl,
                                    height: 88,
                                    width: 88,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) {
                                      return Container(
                                        height: 88,
                                        width: 88,
                                        color: Colors.white,
                                        alignment: Alignment.center,
                                        child: Icon(
                                          Icons.broken_image_outlined,
                                          color: AppColors.hintColor.withValues(
                                            alpha: 0.75,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                          ),
                          const Gap(14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.product.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.blackColor,
                                  ),
                                ),
                                const Gap(6),
                                Text(
                                  widget.product.title,
                                  style: TextStyle(
                                    fontSize: 13,
                                    height: 1.4,
                                    color: AppColors.hintColor.withValues(
                                      alpha: 0.92,
                                    ),
                                  ),
                                ),
                                const Gap(10),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: [
                                    _MetaChip(
                                      label: context.tr('Qty {count}', {
                                        'count': widget.quantity,
                                      }),
                                      icon: Icons.layers_outlined,
                                    ),
                                    if (widget.selectedSize != null)
                                      _MetaChip(
                                        label: context.tr('Size {size} UK', {
                                          'size': widget.selectedSize,
                                        }),
                                        icon: Icons.straighten,
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const Gap(8),
                          Text(
                            AppPrice.format(subtotal),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: AppColors.blackColor,
                            ),
                          ),
                        ],
                      ),
                      const Gap(18),
                      Divider(
                        color: Colors.black.withValues(alpha: 0.08),
                        height: 1,
                      ),
                      const Gap(18),
                      _SummaryRow(
                        label: 'Subtotal',
                        value: AppPrice.format(subtotal),
                      ),
                      const Gap(12),
                      _SummaryRow(
                        label: 'Shipping',
                        value: AppPrice.format(shipping),
                      ),
                      if (discountAmount > 0) ...[
                        const Gap(12),
                        _SummaryRow(
                          label: 'Discount',
                          value: AppPrice.discount(discountAmount),
                          valueColor: Colors.green.shade700,
                        ),
                      ],
                      if (_appliedCoupon != null) ...[
                        const Gap(14),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.09),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.local_offer_outlined,
                                size: 18,
                                color: Colors.green.shade700,
                              ),
                              const Gap(8),
                              Expanded(
                                child: Text(
                                  context.tr(
                                    'Coupon {code} applied successfully',
                                    {'code': _appliedCoupon!.code},
                                  ),
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.green.shade700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const Gap(18),
                      Divider(
                        color: Colors.black.withValues(alpha: 0.08),
                        height: 1,
                      ),
                      const Gap(18),
                      _SummaryRow(
                        label: 'Total',
                        value: AppPrice.format(total),
                        isStrong: true,
                      ),
                    ],
                  ),
                ),
                const Gap(16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.black.withValues(alpha: 0.05),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        height: 42,
                        width: 42,
                        decoration: BoxDecoration(
                          color: AppColors.redColor.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.verified_user_outlined,
                          color: AppColors.redColor,
                        ),
                      ),
                      const Gap(12),
                      Expanded(
                        child: Text(
                          context.tr(
                            'Secure checkout with protected order records and delivery details saved to your account.',
                          ),
                          style: TextStyle(
                            fontSize: 13,
                            height: 1.5,
                            color: AppColors.hintColor.withValues(alpha: 0.92),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CheckoutCard extends StatelessWidget {
  const _CheckoutCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.icon,
    required this.title,
    this.actionLabel,
    this.onActionTap,
  });

  final IconData icon;
  final String title;
  final String? actionLabel;
  final VoidCallback? onActionTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            color: AppColors.redColor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: AppColors.redColor),
        ),
        const Gap(12),
        Expanded(
          child: Text(
            context.tr(title),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.blackColor,
            ),
          ),
        ),
        if (actionLabel != null && onActionTap != null)
          TextButton(
            onPressed: onActionTap,
            child: Text(
              context.tr(actionLabel!),
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.redColor,
              ),
            ),
          ),
      ],
    );
  }
}

class _CouponBox extends StatelessWidget {
  const _CouponBox({
    required this.controller,
    required this.onApplyCoupon,
    required this.onRemoveCoupon,
    required this.isApplyingCoupon,
    this.couponMessage,
    this.appliedCouponCode,
  });

  final TextEditingController controller;
  final VoidCallback onApplyCoupon;
  final VoidCallback onRemoveCoupon;
  final bool isApplyingCoupon;
  final String? couponMessage;
  final String? appliedCouponCode;

  bool get _hasCoupon => appliedCouponCode != null;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.local_offer_outlined, color: AppColors.redColor),
            const Gap(10),
            Expanded(
              child: Text(
                context.tr(_hasCoupon ? 'Coupon Applied' : 'Apply Coupon'),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.blackColor,
                ),
              ),
            ),
            if (_hasCoupon)
              IconButton(
                tooltip: context.tr('Remove coupon'),
                onPressed: onRemoveCoupon,
                icon: const Icon(Icons.close_rounded),
                color: AppColors.hintColor,
              ),
          ],
        ),
        const Gap(14),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                readOnly: _hasCoupon,
                textCapitalization: TextCapitalization.characters,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) {
                  if (!_hasCoupon && !isApplyingCoupon) {
                    onApplyCoupon();
                  }
                },
                decoration: InputDecoration(
                  hintText: context.tr('Enter coupon code'),
                  filled: true,
                  fillColor: AppColors.primaryColor,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const Gap(10),
            SizedBox(
              height: 50,
              child: FilledButton(
                onPressed: isApplyingCoupon || _hasCoupon
                    ? null
                    : onApplyCoupon,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.redColor,
                  disabledBackgroundColor: AppColors.redColor.withValues(
                    alpha: 0.45,
                  ),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: isApplyingCoupon
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        context.tr('Apply'),
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
              ),
            ),
          ],
        ),
        if (couponMessage != null) ...[
          const Gap(10),
          Text(
            couponMessage!,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: _hasCoupon ? const Color(0xFF1E8E5A) : Colors.orange,
            ),
          ),
        ],
      ],
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.tr(title),
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.blackColor,
            ),
          ),
          const Gap(8),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 13,
              height: 1.5,
              color: AppColors.hintColor.withValues(alpha: 0.92),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyStateTile extends StatelessWidget {
  const _EmptyStateTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.buttonLabel,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String buttonLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.hintColor),
          const Gap(10),
          Text(
            context.tr(title),
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.blackColor,
            ),
          ),
          const Gap(6),
          Text(
            context.tr(subtitle),
            style: TextStyle(
              fontSize: 13,
              height: 1.5,
              color: AppColors.hintColor.withValues(alpha: 0.92),
            ),
          ),
          const Gap(12),
          OutlinedButton(
            onPressed: onTap,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.redColor,
              side: BorderSide(
                color: AppColors.redColor.withValues(alpha: 0.5),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Text(
              context.tr(buttonLabel),
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: AppColors.hintColor),
          const Gap(6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.hintColor.withValues(alpha: 0.95),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.isStrong = false,
  });

  final String label;
  final String value;
  final Color? valueColor;
  final bool isStrong;

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontSize: isStrong ? 16 : 14,
      fontWeight: isStrong ? FontWeight.w800 : FontWeight.w500,
      color: isStrong ? AppColors.blackColor : AppColors.hintColor,
    );

    return Row(
      children: [
        Text(context.tr(label), style: textStyle),
        const Spacer(),
        Text(
          value,
          style: textStyle.copyWith(
            color: valueColor ?? (isStrong ? AppColors.blackColor : null),
          ),
        ),
      ],
    );
  }
}
