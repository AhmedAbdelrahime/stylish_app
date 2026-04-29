import 'package:flutter/material.dart';
import 'package:hungry/core/api/supabase_error_mapper.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/pages/orders/data/order_history_model.dart';
import 'package:hungry/pages/orders/data/order_history_service.dart';
import 'package:hungry/pages/product/widgets/product_app_bar.dart';

class OrderDetailsPage extends StatefulWidget {
  const OrderDetailsPage({super.key, required this.orderId, this.initialOrder});

  final String orderId;
  final OrderHistoryModel? initialOrder;

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  final OrderHistoryService _orderService = OrderHistoryService();

  OrderHistoryModel? _order;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _order = widget.initialOrder;
    _isLoading = widget.initialOrder == null;
    _loadOrder(silent: widget.initialOrder != null);
  }

  Future<void> _loadOrder({bool silent = false}) async {
    if (!silent) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }

    try {
      final order = await _orderService.getOrder(widget.orderId);
      if (!mounted) return;

      setState(() {
        _order = order;
        _isLoading = false;
        _errorMessage = order == null ? 'Order not found.' : null;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _errorMessage = SupabaseErrorMapper.map(error);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Column(
        children: [
          const ProductAppBar(text: 'Order Details'),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading && _order == null) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.redColor),
      );
    }

    final order = _order;
    if (order == null) {
      return _StateMessage(
        title: 'Order unavailable',
        message: _errorMessage ?? 'This order could not be loaded.',
        onRetry: _loadOrder,
      );
    }

    return RefreshIndicator(
      color: AppColors.redColor,
      onRefresh: () => _loadOrder(silent: true),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
        children: [
          _SummaryHeader(order: order),
          const SizedBox(height: 14),
          _TrackingTimeline(order: order),
          const SizedBox(height: 14),
          _InfoSection(
            title: 'Items',
            child: Column(
              children: [
                for (var index = 0; index < order.items.length; index++) ...[
                  _OrderItemRow(
                    item: order.items[index],
                    currency: order.currency,
                  ),
                  if (index != order.items.length - 1)
                    Divider(height: 24, color: Colors.grey.shade200),
                ],
              ],
            ),
          ),
          const SizedBox(height: 14),
          _PaymentSection(order: order),
          const SizedBox(height: 14),
          _InfoSection(
            title: 'Delivery Address',
            child: Text(
              order.shippingAddress?.trim().isNotEmpty == true
                  ? order.shippingAddress!
                  : 'No delivery address saved for this order.',
              style: const TextStyle(
                color: AppColors.hintColor,
                fontSize: 13,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryHeader extends StatelessWidget {
  const _SummaryHeader({required this.order});

  final OrderHistoryModel order;

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(order);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 52,
                width: 52,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(Icons.receipt_long_outlined, color: color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.shortId,
                      style: const TextStyle(
                        color: AppColors.blackColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Placed ${_formatDate(order.createdAt)}',
                      style: const TextStyle(
                        color: AppColors.hintColor,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              _StatusPill(text: order.deliveryLabel, color: color),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _HeaderMetric(
                label: 'Items',
                value: order.totalQuantity.toString(),
              ),
              _HeaderMetric(label: 'Payment', value: order.paymentLabel),
              _HeaderMetric(
                label: 'Total',
                value: '${order.currency} ${_price(order.totalAmount)}',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeaderMetric extends StatelessWidget {
  const _HeaderMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: AppColors.hintColor, fontSize: 11),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.blackColor,
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _TrackingTimeline extends StatelessWidget {
  const _TrackingTimeline({required this.order});

  final OrderHistoryModel order;

  static const _steps = [
    _TrackingStep(
      status: 'pending',
      title: 'Order placed',
      subtitle: 'We received your order.',
      icon: Icons.check_circle_outline,
    ),
    _TrackingStep(
      status: 'packed',
      title: 'Packed',
      subtitle: 'Your items are being prepared.',
      icon: Icons.inventory_2_outlined,
    ),
    _TrackingStep(
      status: 'shipped',
      title: 'Shipped',
      subtitle: 'The order is on the way.',
      icon: Icons.local_shipping_outlined,
    ),
    _TrackingStep(
      status: 'delivered',
      title: 'Delivered',
      subtitle: 'The order reached your address.',
      icon: Icons.home_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    if (order.isCancelled) {
      return _InfoSection(
        title: 'Tracking',
        child: Row(
          children: [
            Icon(Icons.cancel_outlined, color: Colors.red.shade700),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                'This order was cancelled.',
                style: TextStyle(
                  color: AppColors.blackColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return _InfoSection(
      title: 'Tracking',
      child: Column(
        children: List.generate(_steps.length, (index) {
          final step = _steps[index];
          final isComplete = index <= order.deliveryStepIndex;
          final isCurrent = index == order.deliveryStepIndex;

          return _TrackingRow(
            step: step,
            isComplete: isComplete,
            isCurrent: isCurrent,
            isLast: index == _steps.length - 1,
          );
        }),
      ),
    );
  }
}

class _TrackingRow extends StatelessWidget {
  const _TrackingRow({
    required this.step,
    required this.isComplete,
    required this.isCurrent,
    required this.isLast,
  });

  final _TrackingStep step;
  final bool isComplete;
  final bool isCurrent;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final color = isComplete ? AppColors.redColor : Colors.grey.shade300;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              height: 36,
              width: 36,
              decoration: BoxDecoration(
                color: isComplete
                    ? AppColors.redColor.withValues(alpha: 0.12)
                    : Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(step.icon, color: color, size: 19),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 34,
                color: isComplete ? AppColors.redColor : Colors.grey.shade300,
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.title,
                  style: TextStyle(
                    color: isComplete
                        ? AppColors.blackColor
                        : AppColors.hintColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  isCurrent ? 'Current status' : step.subtitle,
                  style: const TextStyle(
                    color: AppColors.hintColor,
                    fontSize: 12,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _TrackingStep {
  const _TrackingStep({
    required this.status,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String status;
  final String title;
  final String subtitle;
  final IconData icon;
}

class _OrderItemRow extends StatelessWidget {
  const _OrderItemRow({required this.item, required this.currency});

  final OrderHistoryItem item;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final imageUrl = item.productImageUrl;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Container(
            height: 62,
            width: 62,
            color: Colors.grey.shade100,
            child: imageUrl == null || imageUrl.trim().isEmpty
                ? const Icon(Icons.image_outlined, color: AppColors.hintColor)
                : Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.image_outlined,
                      color: AppColors.hintColor,
                    ),
                  ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.displayTitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.blackColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Qty ${item.quantity}${item.selectedSize == null ? '' : ' · Size ${item.selectedSize}'}',
                style: const TextStyle(
                  color: AppColors.hintColor,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Text(
          '$currency ${_price(item.lineTotal)}',
          style: const TextStyle(
            color: AppColors.blackColor,
            fontSize: 13,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _PaymentSection extends StatelessWidget {
  const _PaymentSection({required this.order});

  final OrderHistoryModel order;

  @override
  Widget build(BuildContext context) {
    return _InfoSection(
      title: 'Payment Summary',
      child: Column(
        children: [
          _AmountRow(
            label: 'Subtotal',
            value: '${order.currency} ${_price(order.subtotal)}',
          ),
          _AmountRow(
            label: 'Shipping',
            value: '${order.currency} ${_price(order.shippingFee)}',
          ),
          if (order.discountAmount > 0)
            _AmountRow(
              label: 'Discount',
              value: '- ${order.currency} ${_price(order.discountAmount)}',
              valueColor: Colors.green.shade700,
            ),
          Divider(height: 24, color: Colors.grey.shade200),
          _AmountRow(
            label: 'Total',
            value: '${order.currency} ${_price(order.totalAmount)}',
            isStrong: true,
          ),
        ],
      ),
    );
  }
}

class _AmountRow extends StatelessWidget {
  const _AmountRow({
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: isStrong ? AppColors.blackColor : AppColors.hintColor,
                fontSize: isStrong ? 15 : 13,
                fontWeight: isStrong ? FontWeight.w800 : FontWeight.w500,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: valueColor ?? AppColors.blackColor,
              fontSize: isStrong ? 16 : 13,
              fontWeight: isStrong ? FontWeight.w900 : FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  const _InfoSection({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.blackColor,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _StateMessage extends StatelessWidget {
  const _StateMessage({
    required this.title,
    required this.message,
    required this.onRetry,
  });

  final String title;
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.receipt_long_outlined,
              size: 54,
              color: AppColors.redColor,
            ),
            const SizedBox(height: 14),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.blackColor,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.hintColor,
                fontSize: 13,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 18),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.redColor,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}

Color _statusColor(OrderHistoryModel order) {
  if (order.isCancelled) return Colors.red.shade700;
  if (order.isDelivered) return Colors.green.shade700;

  switch (order.deliveryStatus.toLowerCase()) {
    case 'packed':
      return Colors.deepPurple.shade600;
    case 'shipped':
      return Colors.blue.shade700;
    default:
      return AppColors.redColor;
  }
}

String _formatDate(DateTime value) {
  final day = value.day.toString().padLeft(2, '0');
  final month = value.month.toString().padLeft(2, '0');
  return '$day/$month/${value.year}';
}

String _price(double value) {
  if (value == value.roundToDouble()) {
    return value.toStringAsFixed(0);
  }

  return value.toStringAsFixed(2);
}
