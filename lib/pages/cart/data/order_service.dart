import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:hungry/core/config/store_config.dart';
import 'package:hungry/pages/cart/data/cart_item_model.dart';
import 'package:hungry/pages/cart/data/coupon_service.dart';
import 'package:hungry/pages/home/models/product_model.dart';
import 'package:hungry/pages/settings/data/profile_service.dart';

class OrderService {
  OrderService({SupabaseClient? supabase, ProfileService? profileService})
    : _supabase = supabase ?? Supabase.instance.client,
      _profileService = profileService ?? ProfileService();

  final SupabaseClient _supabase;
  final ProfileService _profileService;

  Future<String> createSingleItemOrder({
    required ProductModel product,
    required int quantity,
    String? selectedSize,
    AppliedCoupon? coupon,
    String? notes,
  }) async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }

    final unitPrice = product.effectivePrice;
    final subtotal = unitPrice * quantity;
    const shippingFee = StoreConfig.standardDeliveryFee;
    final discountAmount = coupon?.discountAmount ?? 0.0;
    final totalAmount = subtotal + shippingFee - discountAmount;

    final profile = await _profileService.getProfile();
    final shippingAddress = _composeShippingAddress(profile);
    final contactPhone = _composeContactPhone(profile);
    final orderNotes = _composeOrderNotes(
      coupon: coupon,
      contactPhone: contactPhone,
      notes: notes,
    );

    final orderId = await _createOrderWithItems(
      orderPayload: {
        'status': 'pending',
        'payment_status': 'pending',
        'delivery_status': 'pending',
        'subtotal': subtotal,
        'shipping_fee': shippingFee,
        'discount_amount': discountAmount,
        'total_amount': totalAmount,
        'currency': StoreConfig.currencyCode,
        'shipping_address': shippingAddress,
        'notes': orderNotes,
      },
      itemPayloads: [
        {
          'product_id': product.id,
          'product_name': product.name,
          'product_title': product.title,
          'product_image_url': product.primaryImage.isEmpty
              ? null
              : product.primaryImage,
          'unit_price': unitPrice,
          'quantity': quantity,
          'selected_size': selectedSize,
        },
      ],
    );

    if (coupon != null) {
      await _supabase.rpc(
        'redeem_coupon_usage',
        params: {'coupon_id_input': coupon.id},
      );
    }

    return orderId;
  }

  Future<String> createCartOrder({
    required List<CartItemModel> items,
    AppliedCoupon? coupon,
    String? notes,
  }) async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }

    if (items.isEmpty) {
      throw Exception('Your cart is empty.');
    }

    final subtotal = items.fold<double>(0, (sum, item) => sum + item.lineTotal);
    const shippingFee = StoreConfig.standardDeliveryFee;
    final discountAmount = coupon?.discountAmount ?? 0.0;
    final totalAmount = subtotal + shippingFee - discountAmount;

    final profile = await _profileService.getProfile();
    final shippingAddress = _composeShippingAddress(profile);
    final contactPhone = _composeContactPhone(profile);
    final orderItems = items
        .map(
          (item) => {
            'product_id': item.productId,
            'product_name': item.name,
            'product_title': item.productTitle,
            'product_image_url': item.imagePath.isEmpty ? null : item.imagePath,
            'unit_price': item.price,
            'quantity': item.quantity,
            'selected_size': item.size,
          },
        )
        .toList();

    final orderId = await _createOrderWithItems(
      orderPayload: {
        'status': 'pending',
        'payment_status': 'pending',
        'delivery_status': 'pending',
        'subtotal': subtotal,
        'shipping_fee': shippingFee,
        'discount_amount': discountAmount,
        'total_amount': totalAmount,
        'currency': StoreConfig.currencyCode,
        'shipping_address': shippingAddress,
        'notes': _composeOrderNotes(
          coupon: coupon,
          contactPhone: contactPhone,
          notes: notes,
        ),
      },
      itemPayloads: orderItems,
    );

    if (coupon != null) {
      await _supabase.rpc(
        'redeem_coupon_usage',
        params: {'coupon_id_input': coupon.id},
      );
    }

    return orderId;
  }

  String _composeOrderNotes({
    AppliedCoupon? coupon,
    String? contactPhone,
    String? notes,
  }) {
    final parts = [
      '${StoreOrderNoteLabels.payment}: ${StorePayment.cashOnDeliveryLabel}',
      if (contactPhone != null && contactPhone.trim().isNotEmpty)
        '${StoreOrderNoteLabels.phone}: ${contactPhone.trim()}',
      if (coupon != null) '${StoreOrderNoteLabels.coupon}: ${coupon.code}',
      if (notes != null && notes.trim().isNotEmpty) notes.trim(),
    ];

    return parts.join(' | ');
  }

  Future<String> _createOrderWithItems({
    required Map<String, dynamic> orderPayload,
    required List<Map<String, dynamic>> itemPayloads,
  }) async {
    if (itemPayloads.isEmpty) {
      throw Exception('Your cart is empty.');
    }

    try {
      return await _callCreateOrderRpc(
        orderPayload: orderPayload,
        itemPayloads: itemPayloads,
      );
    } catch (error) {
      if (_isSelectedSizeBackendTypeError(error, itemPayloads)) {
        final compatibleItemPayloads = _legacySelectedSizePayloads(
          itemPayloads,
        );

        try {
          return await _callCreateOrderRpc(
            orderPayload: orderPayload,
            itemPayloads: compatibleItemPayloads,
          );
        } catch (retryError) {
          if (!_isCreateOrderRpcMissing(retryError)) {
            rethrow;
          }

          return _createOrderWithDirectInserts(
            orderPayload: orderPayload,
            itemPayloads: compatibleItemPayloads,
          );
        }
      }

      if (!_isCreateOrderRpcMissing(error)) {
        rethrow;
      }

      return _createOrderWithDirectInserts(
        orderPayload: orderPayload,
        itemPayloads: itemPayloads,
      );
    }
  }

  Future<String> _callCreateOrderRpc({
    required Map<String, dynamic> orderPayload,
    required List<Map<String, dynamic>> itemPayloads,
  }) async {
    final orderId = await _supabase.rpc(
      'create_order_with_items',
      params: {'order_payload': orderPayload, 'item_payloads': itemPayloads},
    );

    return orderId.toString();
  }

  Future<String> _createOrderWithDirectInserts({
    required Map<String, dynamic> orderPayload,
    required List<Map<String, dynamic>> itemPayloads,
  }) async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }

    final orderData = await _supabase
        .from('orders')
        .insert({...orderPayload, 'user_id': user.id})
        .select('id')
        .single();

    final orderId = orderData['id'] as String;
    final orderItems = itemPayloads
        .map((item) => {...item, 'order_id': orderId})
        .toList(growable: false);

    try {
      await _supabase.from('order_items').insert(orderItems);
    } catch (error) {
      if (!_isSelectedSizeBackendTypeError(error, itemPayloads)) {
        rethrow;
      }

      final compatibleOrderItems = _legacySelectedSizePayloads(
        itemPayloads,
      ).map((item) => {...item, 'order_id': orderId}).toList(growable: false);
      await _supabase.from('order_items').insert(compatibleOrderItems);
    }

    return orderId;
  }

  bool _isCreateOrderRpcMissing(Object error) {
    final message = error.toString();
    return message.contains("Could not find the function") ||
        message.contains("function public.create_order_with_items") ||
        message.contains("PGRST202");
  }

  bool _isSelectedSizeBackendTypeError(
    Object error,
    List<Map<String, dynamic>> itemPayloads,
  ) {
    final message = error.toString().toLowerCase();
    final hasSelectedSize = itemPayloads.any((item) {
      final selectedSize = item['selected_size']?.toString().trim();
      return selectedSize != null && selectedSize.isNotEmpty;
    });
    final hasTextSelectedSize = itemPayloads.any((item) {
      final selectedSize = item['selected_size']?.toString().trim();
      return selectedSize != null &&
          selectedSize.isNotEmpty &&
          int.tryParse(selectedSize) == null;
    });

    return hasSelectedSize &&
        ((message.contains('selected_size') && message.contains('integer')) ||
            (hasTextSelectedSize &&
                (message.contains('invalid input syntax') ||
                    message.contains('22p02'))));
  }

  List<Map<String, dynamic>> _legacySelectedSizePayloads(
    List<Map<String, dynamic>> itemPayloads,
  ) {
    return itemPayloads
        .map(
          (item) => {
            ...item,
            'selected_size': _legacySelectedSizeValue(item['selected_size']),
          },
        )
        .toList(growable: false);
  }

  Object? _legacySelectedSizeValue(Object? selectedSize) {
    final normalized = selectedSize?.toString().trim();
    if (normalized == null || normalized.isEmpty) {
      return null;
    }

    return int.tryParse(normalized);
  }

  String? _composeShippingAddress(dynamic profile) {
    if (profile == null) return null;

    final parts =
        [
              profile.address,
              profile.city,
              profile.state,
              profile.country,
              profile.pincode,
            ]
            .whereType<String>()
            .map((value) => value.trim())
            .where((v) => v.isNotEmpty);

    final joined = parts.join(', ');
    return joined.isEmpty ? null : joined;
  }

  String? _composeContactPhone(dynamic profile) {
    if (profile == null) return null;

    final phone = profile.phone?.toString().trim();
    return phone == null || phone.isEmpty ? null : phone;
  }
}
