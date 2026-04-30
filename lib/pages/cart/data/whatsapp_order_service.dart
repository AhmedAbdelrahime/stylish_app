import 'package:hungry/core/config/store_config.dart';
import 'package:hungry/pages/cart/data/cart_item_model.dart';
import 'package:hungry/pages/home/models/product_model.dart';
import 'package:hungry/pages/orders/data/order_history_model.dart';
import 'package:url_launcher/url_launcher.dart';

class WhatsAppOrderLine {
  const WhatsAppOrderLine({
    required this.name,
    required this.title,
    required this.unitPrice,
    required this.quantity,
    this.selectedSize,
  });

  factory WhatsAppOrderLine.fromCartItem(CartItemModel item) {
    return WhatsAppOrderLine(
      name: item.name,
      title: item.productTitle,
      unitPrice: item.price,
      quantity: item.quantity,
      selectedSize: item.size,
    );
  }

  factory WhatsAppOrderLine.fromProduct({
    required ProductModel product,
    required int quantity,
    String? selectedSize,
  }) {
    return WhatsAppOrderLine(
      name: product.name,
      title: product.title,
      unitPrice: product.effectivePrice,
      quantity: quantity,
      selectedSize: selectedSize,
    );
  }

  factory WhatsAppOrderLine.fromOrderItem(OrderHistoryItem item) {
    return WhatsAppOrderLine(
      name: item.productName,
      title: item.displayTitle,
      unitPrice: item.unitPrice,
      quantity: item.quantity,
      selectedSize: item.selectedSize,
    );
  }

  final String name;
  final String title;
  final double unitPrice;
  final int quantity;
  final String? selectedSize;

  double get lineTotal => unitPrice * quantity;
}

class WhatsAppOrderRequest {
  const WhatsAppOrderRequest({
    required this.lines,
    required this.subtotal,
    required this.shippingFee,
    required this.discountAmount,
    required this.totalAmount,
    required this.currency,
    required this.shippingAddress,
    this.orderId,
    this.customerName,
    this.customerEmail,
    this.customerPhone,
    this.paymentLabel,
    this.statusLabel,
    this.note,
  });

  factory WhatsAppOrderRequest.fromOrder(OrderHistoryModel order) {
    return WhatsAppOrderRequest(
      orderId: order.id,
      lines: order.items.map(WhatsAppOrderLine.fromOrderItem).toList(),
      subtotal: order.subtotal,
      shippingFee: order.shippingFee,
      discountAmount: order.discountAmount,
      totalAmount: order.totalAmount,
      currency: order.currency,
      shippingAddress: order.shippingAddress,
      paymentLabel: order.paymentLabel,
      statusLabel: order.deliveryLabel,
      note: 'Customer is asking about this order.',
    );
  }

  final String? orderId;
  final List<WhatsAppOrderLine> lines;
  final double subtotal;
  final double shippingFee;
  final double discountAmount;
  final double totalAmount;
  final String currency;
  final String? customerName;
  final String? customerEmail;
  final String? customerPhone;
  final String? shippingAddress;
  final String? paymentLabel;
  final String? statusLabel;
  final String? note;
}

class WhatsAppOrderException implements Exception {
  const WhatsAppOrderException(this.message);

  final String message;

  @override
  String toString() => message;
}

class WhatsAppOrderService {
  const WhatsAppOrderService();

  Future<void> openOrder(WhatsAppOrderRequest request) async {
    final message = _buildMessage(request);
    final phone = _digitsOnly(StoreContact.whatsAppBusinessPhone);

    final appUri = Uri(
      scheme: 'whatsapp',
      host: 'send',
      queryParameters: {if (phone.isNotEmpty) 'phone': phone, 'text': message},
    );

    if (await canLaunchUrl(appUri)) {
      final opened = await launchUrl(
        appUri,
        mode: LaunchMode.externalApplication,
      );
      if (opened) return;
    }

    final webUri = Uri.https('wa.me', phone.isEmpty ? '/' : '/$phone', {
      'text': message,
    });

    final opened = await launchUrl(
      webUri,
      mode: LaunchMode.externalApplication,
    );
    if (opened) return;

    throw const WhatsAppOrderException(
      'Could not open WhatsApp on this device.',
    );
  }

  String _buildMessage(WhatsAppOrderRequest request) {
    final buffer = StringBuffer()
      ..writeln(StoreOrderMessages.orderGreeting())
      ..writeln(StoreOrderMessages.orderIntro)
      ..writeln();

    if (request.orderId != null && request.orderId!.trim().isNotEmpty) {
      buffer.writeln('Order ID: ${_shortOrderId(request.orderId!)}');
    }

    final name = request.customerName?.trim();
    if (name != null && name.isNotEmpty) {
      buffer.writeln('Customer: $name');
    }

    final email = request.customerEmail?.trim();
    if (email != null && email.isNotEmpty) {
      buffer.writeln('Email: $email');
    }

    final customerPhone = request.customerPhone?.trim();
    if (customerPhone != null && customerPhone.isNotEmpty) {
      buffer.writeln('Phone: $customerPhone');
    }

    if (request.paymentLabel != null && request.paymentLabel!.isNotEmpty) {
      buffer.writeln('Payment: ${request.paymentLabel}');
    }

    if (request.statusLabel != null && request.statusLabel!.isNotEmpty) {
      buffer.writeln('Status: ${request.statusLabel}');
    }

    buffer
      ..writeln()
      ..writeln('Items:');

    for (var index = 0; index < request.lines.length; index++) {
      final line = request.lines[index];
      final title = line.title.trim().isNotEmpty ? line.title : line.name;
      final size = line.selectedSize == null
          ? ''
          : ' | Size: ${line.selectedSize}';

      buffer
        ..writeln('${index + 1}. $title')
        ..writeln(
          '   Qty: ${line.quantity}$size | Unit: ${AppPrice.format(line.unitPrice, currencyCode: request.currency)} | Line: ${AppPrice.format(line.lineTotal, currencyCode: request.currency)}',
        );
    }

    buffer
      ..writeln()
      ..writeln(
        'Subtotal: ${AppPrice.format(request.subtotal, currencyCode: request.currency)}',
      )
      ..writeln(
        'Shipping: ${AppPrice.format(request.shippingFee, currencyCode: request.currency)}',
      );

    if (request.discountAmount > 0) {
      buffer.writeln(
        'Discount: ${AppPrice.discount(request.discountAmount, currencyCode: request.currency)}',
      );
    }

    buffer.writeln(
      'Total: ${AppPrice.format(request.totalAmount, currencyCode: request.currency)}',
    );

    final address = request.shippingAddress?.trim();
    if (address != null && address.isNotEmpty) {
      buffer
        ..writeln()
        ..writeln('Delivery address:')
        ..writeln(address);
    }

    final note = request.note?.trim();
    if (note != null && note.isNotEmpty) {
      buffer
        ..writeln()
        ..writeln('Note: $note');
    }

    return buffer.toString().trim();
  }

  String _shortOrderId(String orderId) {
    final compact = orderId.replaceAll('-', '');
    final preview = compact.length >= 8 ? compact.substring(0, 8) : compact;
    return '#${preview.toUpperCase()}';
  }

  String _digitsOnly(String value) => value.replaceAll(RegExp(r'[^0-9]'), '');
}
