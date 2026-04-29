import 'package:hungry/pages/orders/data/order_history_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OrderHistoryService {
  OrderHistoryService({SupabaseClient? supabase})
    : _supabase = supabase ?? Supabase.instance.client;

  final SupabaseClient _supabase;

  static const String _orderSelect = '''
    id,
    status,
    payment_status,
    delivery_status,
    subtotal,
    shipping_fee,
    discount_amount,
    total_amount,
    currency,
    shipping_address,
    notes,
    created_at,
    updated_at,
    order_items (
      id,
      order_id,
      product_id,
      product_name,
      product_title,
      product_image_url,
      unit_price,
      quantity,
      selected_size
    )
  ''';

  Future<List<OrderHistoryModel>> getOrders() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return const [];

    final data = await _supabase
        .from('orders')
        .select(_orderSelect)
        .eq('user_id', user.id)
        .order('created_at', ascending: false);

    return data
        .whereType<Map>()
        .map(
          (item) => OrderHistoryModel.fromJson(
            item.map((key, value) => MapEntry(key.toString(), value)),
          ),
        )
        .toList();
  }

  Future<OrderHistoryModel?> getOrder(String orderId) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return null;

    final data = await _supabase
        .from('orders')
        .select(_orderSelect)
        .eq('id', orderId)
        .eq('user_id', user.id)
        .maybeSingle();

    if (data == null) return null;

    return OrderHistoryModel.fromJson(
      data.map((key, value) => MapEntry(key.toString(), value)),
    );
  }
}
