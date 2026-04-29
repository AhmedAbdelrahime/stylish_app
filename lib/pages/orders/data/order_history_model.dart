class OrderHistoryItem {
  const OrderHistoryItem({
    required this.id,
    required this.orderId,
    required this.productName,
    required this.unitPrice,
    required this.quantity,
    this.productId,
    this.productTitle,
    this.productImageUrl,
    this.selectedSize,
  });

  final String id;
  final String orderId;
  final String? productId;
  final String productName;
  final String? productTitle;
  final String? productImageUrl;
  final double unitPrice;
  final int quantity;
  final int? selectedSize;

  factory OrderHistoryItem.fromJson(Map<String, dynamic> json) {
    return OrderHistoryItem(
      id: json['id'].toString(),
      orderId: (json['order_id'] ?? '').toString(),
      productId: json['product_id']?.toString(),
      productName: (json['product_name'] ?? 'Product').toString(),
      productTitle: json['product_title']?.toString(),
      productImageUrl: json['product_image_url']?.toString(),
      unitPrice: (json['unit_price'] as num?)?.toDouble() ?? 0,
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
      selectedSize: (json['selected_size'] as num?)?.toInt(),
    );
  }

  double get lineTotal => unitPrice * quantity;

  String get displayTitle {
    final title = productTitle?.trim();
    return title == null || title.isEmpty ? productName : title;
  }
}

class OrderHistoryModel {
  const OrderHistoryModel({
    required this.id,
    required this.status,
    required this.paymentStatus,
    required this.deliveryStatus,
    required this.subtotal,
    required this.shippingFee,
    required this.discountAmount,
    required this.totalAmount,
    required this.currency,
    required this.createdAt,
    required this.updatedAt,
    required this.items,
    this.shippingAddress,
    this.notes,
  });

  final String id;
  final String status;
  final String paymentStatus;
  final String deliveryStatus;
  final double subtotal;
  final double shippingFee;
  final double discountAmount;
  final double totalAmount;
  final String currency;
  final String? shippingAddress;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<OrderHistoryItem> items;

  factory OrderHistoryModel.fromJson(Map<String, dynamic> json) {
    final rawItems = json['order_items'];
    final items = rawItems is List
        ? rawItems
              .whereType<Map>()
              .map(
                (item) => OrderHistoryItem.fromJson(
                  item.map((key, value) => MapEntry(key.toString(), value)),
                ),
              )
              .toList()
        : <OrderHistoryItem>[];

    return OrderHistoryModel(
      id: json['id'].toString(),
      status: (json['status'] ?? 'pending').toString(),
      paymentStatus: (json['payment_status'] ?? 'pending').toString(),
      deliveryStatus: (json['delivery_status'] ?? 'pending').toString(),
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0,
      shippingFee: (json['shipping_fee'] as num?)?.toDouble() ?? 0,
      discountAmount: (json['discount_amount'] as num?)?.toDouble() ?? 0,
      totalAmount: (json['total_amount'] as num?)?.toDouble() ?? 0,
      currency: (json['currency'] ?? 'INR').toString(),
      shippingAddress: json['shipping_address']?.toString(),
      notes: json['notes']?.toString(),
      createdAt:
          DateTime.tryParse((json['created_at'] ?? '').toString()) ??
          DateTime.now(),
      updatedAt:
          DateTime.tryParse((json['updated_at'] ?? '').toString()) ??
          DateTime.now(),
      items: items,
    );
  }

  String get shortId {
    final compact = id.replaceAll('-', '');
    final preview = compact.length >= 8 ? compact.substring(0, 8) : compact;
    return '#${preview.toUpperCase()}';
  }

  int get totalQuantity =>
      items.fold<int>(0, (sum, item) => sum + item.quantity);

  int get deliveryStepIndex {
    switch (deliveryStatus.toLowerCase()) {
      case 'packed':
        return 1;
      case 'shipped':
        return 2;
      case 'delivered':
        return 3;
      default:
        return 0;
    }
  }

  bool get isCancelled => status.toLowerCase() == 'cancelled';

  bool get isDelivered => deliveryStatus.toLowerCase() == 'delivered';

  String get deliveryLabel => _titleCase(deliveryStatus);

  String get paymentLabel => _titleCase(paymentStatus);

  String get statusLabel => _titleCase(status);

  static String _titleCase(String value) {
    final normalized = value.trim().replaceAll('_', ' ');
    if (normalized.isEmpty) return '';
    return normalized
        .split(' ')
        .where((part) => part.isNotEmpty)
        .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
        .join(' ');
  }
}
