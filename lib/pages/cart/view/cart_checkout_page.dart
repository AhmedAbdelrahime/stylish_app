import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hungry/core/api/supabase_error_mapper.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/pages/cart/data/cart_item_model.dart';
import 'package:hungry/pages/cart/data/cart_service.dart';
import 'package:hungry/pages/cart/data/order_service.dart';
import 'package:hungry/pages/cart/widgets/success_dialog.dart';
import 'package:hungry/pages/product/widgets/product_app_bar.dart';
import 'package:hungry/pages/settings/data/payment_service.dart';
import 'package:hungry/pages/settings/data/profile_service.dart';
import 'package:hungry/pages/settings/data/pyment_model.dart';
import 'package:hungry/pages/settings/data/user_model.dart';
import 'package:hungry/pages/settings/view/add_pyment_card.dart';
import 'package:hungry/pages/settings/view/settings_page.dart';

class CartCheckoutPage extends StatefulWidget {
  const CartCheckoutPage({super.key, required this.items});

  final List<CartItemModel> items;

  @override
  State<CartCheckoutPage> createState() => _CartCheckoutPageState();
}

class _CartCheckoutPageState extends State<CartCheckoutPage> {
  static const double _shippingFee = 30.0;

  final OrderService _orderService = OrderService();
  final ProfileService _profileService = ProfileService();
  final PaymentService _paymentService = PaymentService();
  final CartService _cartService = CartService();

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

  double get _subtotal =>
      widget.items.fold<double>(0, (sum, item) => sum + item.lineTotal);

  double get _discountAmount => widget.items.fold<double>(0, (sum, item) {
    if (!item.hasDiscount || item.originalPrice == null) {
      return sum;
    }

    return sum + ((item.originalPrice! - item.price) * item.quantity);
  });

  double get _total => _subtotal + _shippingFee;

  String? get _shippingAddress {
    final parts = [
      _profile?.address,
      _profile?.city,
      _profile?.state,
      _profile?.country,
      _profile?.pincode,
    ];

    final normalized = parts
        .whereType<String>()
        .map((value) => value.trim())
        .where((value) => value.isNotEmpty)
        .toList();

    if (normalized.isEmpty) {
      return null;
    }

    return normalized.join(', ');
  }

  PaymentMethod? get _selectedPaymentMethod {
    final index = _selectedPaymentIndex;
    if (index == null || index < 0 || index >= _paymentMethods.length) {
      return null;
    }

    return _paymentMethods[index];
  }

  String _price(double value) {
    if (value == value.roundToDouble()) {
      return value.toStringAsFixed(0);
    }

    return value.toStringAsFixed(2);
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
      setState(() {
        _profile = results[0] as UserModel?;
        _paymentMethods = methods;
        if (methods.isEmpty) {
          _selectedPaymentIndex = null;
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

    if (widget.items.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Your cart is empty.')));
      return;
    }

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
      await _orderService.createCartOrder(items: widget.items);
      await _cartService.clearCart();

      if (!mounted) return;

      await showDialog(context: context, builder: (_) => const SuccessDialog());

      if (!mounted) return;
      Navigator.pop(context);
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
                      '₹${_price(_total)}',
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
                  'Confirm your delivery details and payment method before placing this order.',
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
                              'Add a card to make checkout feel seamless the next time too.',
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
                      ...widget.items.map(
                        (item) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _CheckoutItemTile(item: item),
                        ),
                      ),
                      Divider(color: Colors.black.withValues(alpha: 0.08)),
                      const Gap(12),
                      _SummaryRow(
                        label: 'Subtotal',
                        value: '₹${_price(_subtotal)}',
                      ),
                      const Gap(10),
                      _SummaryRow(
                        label: 'Shipping',
                        value: '₹${_price(_shippingFee)}',
                      ),
                      const Gap(10),
                      _SummaryRow(
                        label: 'Savings',
                        value: '- ₹${_price(_discountAmount)}',
                        valueColor: Colors.green.shade700,
                      ),
                      const Gap(14),
                      Divider(color: Colors.black.withValues(alpha: 0.08)),
                      const Gap(14),
                      _SummaryRow(
                        label: 'Total',
                        value: '₹${_price(_total)}',
                        isStrong: true,
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
        Icon(icon, color: AppColors.redColor),
        const Gap(10),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
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
              color: AppColors.hintColor.withValues(alpha: 0.95),
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
  final Future<void> Function() onTap;

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
          Icon(icon, color: AppColors.redColor),
          const Gap(12),
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
              color: AppColors.hintColor.withValues(alpha: 0.95),
            ),
          ),
          const Gap(14),
          OutlinedButton(
            onPressed: onTap,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.redColor,
              side: const BorderSide(color: AppColors.redColor),
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

class _CheckoutItemTile extends StatelessWidget {
  const _CheckoutItemTile({required this.item});

  final CartItemModel item;

  String _price(double value) {
    if (value == value.roundToDouble()) {
      return value.toStringAsFixed(0);
    }

    return value.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    final imagePath = item.imagePath.trim();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: imagePath.isEmpty
              ? Container(
                  height: 84,
                  width: 84,
                  color: AppColors.primaryColor,
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.image_not_supported_outlined,
                    color: AppColors.hintColor.withValues(alpha: 0.75),
                  ),
                )
              : Image(
                  image: imagePath.startsWith('http')
                      ? NetworkImage(imagePath)
                      : AssetImage(imagePath) as ImageProvider<Object>,
                  height: 84,
                  width: 84,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) {
                    return Container(
                      height: 84,
                      width: 84,
                      color: AppColors.primaryColor,
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.broken_image_outlined,
                        color: AppColors.hintColor.withValues(alpha: 0.75),
                      ),
                    );
                  },
                ),
        ),
        const Gap(12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.name,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.blackColor,
                ),
              ),
              const Gap(4),
              Text(
                item.productTitle,
                style: TextStyle(
                  fontSize: 12,
                  height: 1.4,
                  color: AppColors.hintColor.withValues(alpha: 0.92),
                ),
              ),
              const Gap(8),
              Wrap(
                spacing: 10,
                runSpacing: 8,
                children: [
                  Text(
                    'Qty ${item.quantity}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.hintColor.withValues(alpha: 0.92),
                    ),
                  ),
                  if (item.size != null)
                    Text(
                      'Size ${item.size}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.hintColor.withValues(alpha: 0.92),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
        const Gap(10),
        Text(
          '₹${_price(item.lineTotal)}',
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: AppColors.blackColor,
          ),
        ),
      ],
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
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.hintColor.withValues(alpha: 0.95),
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: isStrong ? 17 : 14,
            fontWeight: isStrong ? FontWeight.w800 : FontWeight.w700,
            color: valueColor ?? AppColors.blackColor,
          ),
        ),
      ],
    );
  }
}
