import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hungry/core/api/supabase_error_mapper.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/pages/cart/data/coupon_service.dart';
import 'package:hungry/pages/cart/data/order_service.dart';
import 'package:hungry/pages/cart/widgets/success_dialog.dart';
import 'package:hungry/pages/home/models/product_model.dart';
import 'package:hungry/pages/orders/view/order_details_page.dart';
import 'package:hungry/pages/product/widgets/product_app_bar.dart';
import 'package:hungry/pages/settings/data/payment_service.dart';
import 'package:hungry/pages/settings/data/profile_service.dart';
import 'package:hungry/pages/settings/data/pyment_model.dart';
import 'package:hungry/pages/settings/data/user_model.dart';
import 'package:hungry/pages/settings/view/add_pyment_card.dart';
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
  final int? selectedSize;
  final AppliedCoupon? appliedCoupon;

  @override
  State<ChekoutPage> createState() => _ChekoutPageState();
}

class _ChekoutPageState extends State<ChekoutPage> {
  final OrderService _orderService = OrderService();
  final ProfileService _profileService = ProfileService();
  final PaymentService _paymentService = PaymentService();

  bool _isSubmitting = false;
  bool _isLoadingDetails = true;
  UserModel? _profile;
  List<PaymentMethod> _paymentMethods = [];
  int? _selectedPaymentIndex;

  @override
  void initState() {
    super.initState();
    _loadCheckoutDetails();
  }

  Future<void> _loadCheckoutDetails() async {
    setState(() {
      _isLoadingDetails = true;
    });

    try {
      final results = await Future.wait<dynamic>([
        _profileService.getProfile(),
        _paymentService.getPaymentMethods(),
      ]);

      if (!mounted) return;

      final methods = results[1] as List<PaymentMethod>;
      final previousSelection = _selectedPaymentIndex;

      setState(() {
        _profile = results[0] as UserModel?;
        _paymentMethods = methods;
        if (methods.isEmpty) {
          _selectedPaymentIndex = null;
        } else if (previousSelection != null &&
            previousSelection >= 0 &&
            previousSelection < methods.length) {
          _selectedPaymentIndex = previousSelection;
        } else {
          _selectedPaymentIndex = 0;
        }
        _isLoadingDetails = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoadingDetails = false;
      });
    }
  }

  String _price(double value) {
    if (value == value.roundToDouble()) {
      return value.toStringAsFixed(0);
    }

    return value.toStringAsFixed(2);
  }

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

  PaymentMethod? get _selectedPaymentMethod {
    final index = _selectedPaymentIndex;
    if (index == null || index < 0 || index >= _paymentMethods.length) {
      return null;
    }

    return _paymentMethods[index];
  }

  Future<void> _openAddressSettings() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SettingsPage()),
    );

    if (!mounted) return;
    await _loadCheckoutDetails();
  }

  Future<void> _openAddCard() async {
    await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const AddPaymentCard()),
    );

    if (!mounted) return;
    await _loadCheckoutDetails();
  }

  Future<void> _submitOrder() async {
    if (_isSubmitting) return;

    if (_shippingAddress == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Add your delivery address in Settings first.'),
        ),
      );
      return;
    }

    if (_selectedPaymentMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Add and select a payment method to continue.'),
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final orderId = await _orderService.createSingleItemOrder(
        product: widget.product,
        quantity: widget.quantity,
        selectedSize: widget.selectedSize,
        coupon: widget.appliedCoupon,
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
      ).showSnackBar(SnackBar(content: Text(message)));
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final unitPrice = widget.product.effectivePrice;
    final subtotal = unitPrice * widget.quantity;
    const shipping = 30.0;
    final discountAmount = widget.appliedCoupon?.discountAmount ?? 0.0;
    final total = subtotal + shipping - discountAmount;
    final imageUrl = widget.product.primaryImage;

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
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Total Payable',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.hintColor.withValues(alpha: 0.85),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Gap(4),
                    Text(
                      '\u20B9${_price(total)}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: AppColors.blackColor,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: FilledButton(
                  onPressed: _isSubmitting ? null : _submitOrder,
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
                      : const Text(
                          'Place Order',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
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
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ProductAppBar(text: 'Checkout', padiing: 0),
                Text(
                  'Review your delivery details and payment before placing the order.',
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
                              'Add your address in Settings so we can deliver this order correctly.',
                          buttonLabel: 'Open Settings',
                          onTap: _openAddressSettings,
                        )
                      else
                        _InfoTile(
                          title: (_profile?.name?.trim().isNotEmpty ?? false)
                              ? _profile!.name!.trim()
                              : 'Delivery destination',
                          subtitle:
                              '${_shippingAddress!}\n${_profile?.email ?? ''}',
                        ),
                    ],
                  ),
                ),
                const Gap(16),
                _CheckoutCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SectionHeader(
                        icon: Icons.credit_card_outlined,
                        title: 'Payment Method',
                        actionLabel: 'Add Card',
                        onActionTap: _openAddCard,
                      ),
                      const Gap(14),
                      if (_paymentMethods.isEmpty)
                        _EmptyStateTile(
                          icon: Icons.wallet_outlined,
                          title: 'No saved cards yet',
                          subtitle:
                              'Add a card to make checkout feel seamless on your next purchase too.',
                          buttonLabel: 'Add Card',
                          onTap: _openAddCard,
                        )
                      else
                        Column(
                          children: List.generate(_paymentMethods.length, (
                            index,
                          ) {
                            final method = _paymentMethods[index];
                            final isSelected = _selectedPaymentIndex == index;

                            return Padding(
                              padding: EdgeInsets.only(
                                bottom: index == _paymentMethods.length - 1
                                    ? 0
                                    : 12,
                              ),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    _selectedPaymentIndex = index;
                                  });
                                },
                                borderRadius: BorderRadius.circular(18),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 180),
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.redColor.withValues(
                                            alpha: 0.08,
                                          )
                                        : AppColors.primaryColor,
                                    borderRadius: BorderRadius.circular(18),
                                    border: Border.all(
                                      color: isSelected
                                          ? AppColors.redColor
                                          : Colors.black.withValues(
                                              alpha: 0.08,
                                            ),
                                      width: isSelected ? 1.6 : 1,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 44,
                                        width: 44,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.credit_card,
                                          color: isSelected
                                              ? AppColors.redColor
                                              : AppColors.hintColor,
                                        ),
                                      ),
                                      const Gap(12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              method.brand.toUpperCase(),
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                                color: AppColors.blackColor,
                                              ),
                                            ),
                                            const Gap(4),
                                            Text(
                                              '**** **** **** ${method.last4}',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: AppColors.hintColor
                                                    .withValues(alpha: 0.95),
                                              ),
                                            ),
                                            if (method.expMonth != null &&
                                                method.expYear != null) ...[
                                              const Gap(2),
                                              Text(
                                                'Expires ${method.expMonth!.toString().padLeft(2, '0')}/${method.expYear}',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: AppColors.hintColor
                                                      .withValues(alpha: 0.82),
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                      Icon(
                                        isSelected
                                            ? Icons.check_circle
                                            : Icons.radio_button_off,
                                        color: isSelected
                                            ? AppColors.redColor
                                            : AppColors.grayColor,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                    ],
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
                                      label: 'Qty ${widget.quantity}',
                                      icon: Icons.layers_outlined,
                                    ),
                                    if (widget.selectedSize != null)
                                      _MetaChip(
                                        label: 'Size ${widget.selectedSize} UK',
                                        icon: Icons.straighten,
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const Gap(8),
                          Text(
                            '\u20B9${_price(subtotal)}',
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
                        value: '\u20B9${_price(subtotal)}',
                      ),
                      const Gap(12),
                      _SummaryRow(
                        label: 'Shipping',
                        value: '\u20B9${_price(shipping)}',
                      ),
                      if (discountAmount > 0) ...[
                        const Gap(12),
                        _SummaryRow(
                          label: 'Discount',
                          value: '- \u20B9${_price(discountAmount)}',
                          valueColor: Colors.green.shade700,
                        ),
                      ],
                      if (widget.appliedCoupon != null) ...[
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
                                  'Coupon ${widget.appliedCoupon!.code} applied successfully',
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
                        value: '\u20B9${_price(total)}',
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
                          'Secure checkout with protected order records and delivery details saved to your account.',
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
            title,
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
              actionLabel!,
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
            title,
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
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.blackColor,
            ),
          ),
          const Gap(6),
          Text(
            subtitle,
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
              buttonLabel,
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
        Text(label, style: textStyle),
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
