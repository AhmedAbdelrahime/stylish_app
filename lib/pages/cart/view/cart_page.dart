import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hungry/core/config/store_config.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/l10n/app_localizations.dart';
import 'package:hungry/pages/cart/data/cart_item_model.dart';
import 'package:hungry/pages/cart/data/cart_service.dart';
import 'package:hungry/pages/cart/view/cart_checkout_page.dart';
import 'package:hungry/pages/cart/widgets/shpping_card.dart';
import 'package:hungry/pages/product/widgets/product_app_bar.dart';
import 'package:hungry/pages/settings/data/profile_service.dart';
import 'package:hungry/pages/settings/data/user_model.dart';
import 'package:hungry/pages/settings/view/settings_page.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  static const double _shippingFee = StoreConfig.standardDeliveryFee;

  final CartService _cartService = CartService();
  final ProfileService _profileService = ProfileService();

  final Set<String> _busyItemIds = <String>{};

  List<CartItemModel> _cartItems = const [];
  UserModel? _profile;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  int get _totalItems =>
      _cartItems.fold<int>(0, (sum, item) => sum + item.quantity);

  double get _subtotal =>
      _cartItems.fold<double>(0, (sum, item) => sum + item.lineTotal);

  double get _discountTotal => _cartItems.fold<double>(0, (sum, item) {
    if (!item.hasDiscount || item.originalPrice == null) {
      return sum;
    }

    return sum + ((item.originalPrice! - item.price) * item.quantity);
  });

  double get _total => _subtotal + (_cartItems.isEmpty ? 0 : _shippingFee);

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

  Future<void> _loadCart({bool silent = false}) async {
    if (!silent) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }

    try {
      final items = await _cartService.getCartItems();

      UserModel? profile;
      try {
        profile = await _profileService.getProfile();
      } catch (_) {
        profile = null;
      }

      if (!mounted) return;

      setState(() {
        _cartItems = items;
        _profile = profile;
        _isLoading = false;
        _errorMessage = null;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  Future<void> _openAddressSettings() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SettingsPage()),
    );

    if (!mounted) return;
    await _loadCart(silent: true);
  }

  Future<void> _updateItemQuantity(CartItemModel item, int nextQuantity) async {
    setState(() {
      _busyItemIds.add(item.id);
    });

    try {
      await _cartService.updateQuantity(
        productId: item.productId,
        selectedSize: item.size,
        quantity: nextQuantity,
      );
      await _loadCart(silent: true);
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
          _busyItemIds.remove(item.id);
        });
      }
    }
  }

  Future<void> _removeItem(CartItemModel item) async {
    setState(() {
      _busyItemIds.add(item.id);
    });

    try {
      await _cartService.removeItem(
        productId: item.productId,
        selectedSize: item.size,
      );
      await _loadCart(silent: true);
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
          _busyItemIds.remove(item.id);
        });
      }
    }
  }

  Future<void> _openCheckout() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            CartCheckoutPage(items: List<CartItemModel>.from(_cartItems)),
      ),
    );

    if (!mounted) return;
    await _loadCart(silent: true);
  }

  @override
  Widget build(BuildContext context) {
    final canGoBack = Navigator.of(context).canPop();
    final savingsLabel = _discountTotal > 0
        ? context.tr('{amount} saved', {
            'amount': AppPrice.format(_discountTotal),
          })
        : context.tr('No active savings');
    final deliveryLabel = _cartItems.isEmpty
        ? context.tr('Start by adding products')
        : _shippingAddress == null
        ? context.tr('Add an address before checkout')
        : context.tr('Standard delivery available');

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
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.tr('Total Payable'),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.hintColor.withValues(alpha: 0.9),
                      ),
                    ),
                    const Gap(4),
                    Text(
                      AppPrice.format(_total),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: AppColors.blackColor,
                      ),
                    ),
                    const Gap(2),
                    Text(
                      deliveryLabel,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _shippingAddress == null && _cartItems.isNotEmpty
                            ? AppColors.redColor
                            : AppColors.hintColor,
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(14),
              Expanded(
                child: FilledButton(
                  onPressed: _cartItems.isEmpty || _isLoading
                      ? null
                      : _openCheckout,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.redColor,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: AppColors.redColor.withValues(
                      alpha: 0.45,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: Text(
                    context.tr('Checkout'),
                    style: const TextStyle(
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
          onRefresh: _loadCart,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 132),
            children: [
              ProductAppBar(text: 'Cart', padiing: 0, showbackicon: canGoBack),
              Text(
                context.tr(
                  'Review saved items, update quantities, and move to checkout when everything looks right.',
                ),
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: AppColors.hintColor.withValues(alpha: 0.95),
                ),
              ),
              const Gap(18),
              Row(
                children: [
                  Expanded(
                    child: _InsightChip(
                      icon: Icons.shopping_bag_outlined,
                      label: context.tr('{count} items', {
                        'count': _totalItems,
                      }),
                    ),
                  ),
                  const Gap(10),
                  Expanded(
                    child: _InsightChip(
                      icon: Icons.sell_outlined,
                      label: savingsLabel,
                    ),
                  ),
                ],
              ),
              const Gap(16),
              _SurfaceCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionHeader(
                      icon: Icons.location_on_outlined,
                      title: 'Delivery Address',
                      actionLabel: _shippingAddress == null ? 'Add' : 'Edit',
                      onTap: _openAddressSettings,
                    ),
                    const Gap(14),
                    if (_shippingAddress == null)
                      _EmptyStateBlock(
                        icon: Icons.home_work_outlined,
                        title: 'No address selected yet',
                        subtitle:
                            'Add your delivery address in Account so checkout can calculate the right destination.',
                        buttonLabel: 'Open Account',
                        onTap: _openAddressSettings,
                      )
                    else
                      Container(
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
                              (_profile?.name?.trim().isNotEmpty ?? false)
                                  ? _profile!.name!.trim()
                                  : context.tr('Delivery destination'),
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: AppColors.blackColor,
                              ),
                            ),
                            const Gap(8),
                            Text(
                              _shippingAddress!,
                              style: TextStyle(
                                fontSize: 13,
                                height: 1.5,
                                color: AppColors.hintColor.withValues(
                                  alpha: 0.95,
                                ),
                              ),
                            ),
                            if ((_profile?.email.trim().isNotEmpty ??
                                false)) ...[
                              const Gap(8),
                              Text(
                                _profile!.email,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.blackColor.withValues(
                                    alpha: 0.8,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              const Gap(16),
              _SurfaceCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _SectionHeader(
                      icon: Icons.local_shipping_outlined,
                      title: 'Delivery Details',
                    ),
                    const Gap(14),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.inventory_2_outlined,
                            color: Colors.green.shade700,
                          ),
                          const Gap(10),
                          Expanded(
                            child: Text(
                              _cartItems.isEmpty
                                  ? context.tr(
                                      'Add products to see a live order summary here.',
                                    )
                                  : context.tr(
                                      'Shipping is {fee} for this order. Item pricing and discounts are pulled from your real product data.',
                                      {'fee': AppPrice.format(_shippingFee)},
                                    ),
                              style: TextStyle(
                                fontSize: 13,
                                height: 1.5,
                                fontWeight: FontWeight.w600,
                                color: Colors.green.shade700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(18),
              Row(
                children: [
                  Text(
                    context.tr('Bag Items'),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.blackColor,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    context.tr('{count} products', {
                      'count': _cartItems.length,
                    }),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.hintColor.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
              const Gap(12),
              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Center(
                    child: CircularProgressIndicator(color: AppColors.redColor),
                  ),
                )
              else if (_errorMessage != null)
                _SurfaceCard(
                  child: _EmptyStateBlock(
                    icon: Icons.error_outline,
                    title: 'We could not load your cart',
                    subtitle: _errorMessage!,
                    buttonLabel: 'Try Again',
                    onTap: () => _loadCart(),
                  ),
                )
              else if (_cartItems.isEmpty)
                _SurfaceCard(
                  child: const _EmptyStateBlock(
                    icon: Icons.shopping_bag_outlined,
                    title: 'Your cart is empty',
                    subtitle:
                        'Products you add from the catalog will appear here with their real pricing and stock status.',
                  ),
                )
              else
                ..._cartItems.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: ShppingCard(
                      item: item,
                      isUpdating: _busyItemIds.contains(item.id),
                      onDecrease: () =>
                          _updateItemQuantity(item, item.quantity - 1),
                      onIncrease: () =>
                          _updateItemQuantity(item, item.quantity + 1),
                      onRemove: () => _removeItem(item),
                    ),
                  ),
                ),
              const Gap(6),
              _SurfaceCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _SectionHeader(
                      icon: Icons.receipt_long_outlined,
                      title: 'Order Summary',
                    ),
                    const Gap(16),
                    _SummaryRow(
                      label: 'Subtotal',
                      value: AppPrice.format(_subtotal),
                    ),
                    const Gap(12),
                    _SummaryRow(
                      label: 'Shipping',
                      value: _cartItems.isEmpty
                          ? AppPrice.format(0)
                          : AppPrice.format(_shippingFee),
                    ),
                    const Gap(12),
                    _SummaryRow(
                      label: 'Savings',
                      value: AppPrice.discount(_discountTotal),
                      valueColor: Colors.green.shade700,
                    ),
                    const Gap(16),
                    Divider(color: Colors.black.withValues(alpha: 0.08)),
                    const Gap(16),
                    _SummaryRow(
                      label: 'Total',
                      value: AppPrice.format(_total),
                      isStrong: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SurfaceCard extends StatelessWidget {
  const _SurfaceCard({required this.child});

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

class _InsightChip extends StatelessWidget {
  const _InsightChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.redColor),
          const Gap(10),
          Expanded(
            child: Text(
              label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.blackColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.icon,
    required this.title,
    this.actionLabel,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String? actionLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.redColor),
        const Gap(10),
        Expanded(
          child: Text(
            context.tr(title),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.blackColor,
            ),
          ),
        ),
        if (actionLabel != null && onTap != null)
          TextButton(
            onPressed: onTap,
            child: Text(
              context.tr(actionLabel!),
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
      fontSize: isStrong ? 17 : 14,
      fontWeight: isStrong ? FontWeight.w800 : FontWeight.w600,
      color: valueColor ?? AppColors.blackColor,
    );

    return Row(
      children: [
        Text(
          context.tr(label),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.hintColor.withValues(alpha: 0.95),
          ),
        ),
        const Spacer(),
        Text(value, style: textStyle),
      ],
    );
  }
}

class _EmptyStateBlock extends StatelessWidget {
  const _EmptyStateBlock({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.buttonLabel,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String? buttonLabel;
  final Future<void> Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 62,
          width: 62,
          decoration: BoxDecoration(
            color: AppColors.redColor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Icon(icon, color: AppColors.redColor),
        ),
        const Gap(14),
        Text(
          context.tr(title),
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.blackColor,
          ),
        ),
        const Gap(8),
        Text(
          context.tr(subtitle),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            height: 1.5,
            color: AppColors.hintColor.withValues(alpha: 0.95),
          ),
        ),
        if (buttonLabel != null && onTap != null) ...[
          const Gap(16),
          OutlinedButton(
            onPressed: onTap,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.redColor,
              side: const BorderSide(color: AppColors.redColor),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              context.tr(buttonLabel!),
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ],
    );
  }
}
