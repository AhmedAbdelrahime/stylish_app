import 'package:flutter/foundation.dart';
import 'package:hungry/pages/home/models/product_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<ProductModel>> getProducts() async {
    try {
      final activeProducts = await _fetchProducts(activeOnly: true);
      if (activeProducts.isNotEmpty) {
        return activeProducts;
      }

      // Fallback so the storefront still works if current rows do not use
      // the expected status values yet.
      return await _fetchProducts(activeOnly: false);
    } catch (error) {
      debugPrint('Error fetching products: $error');
      return [];
    }
  }

  Future<List<ProductModel>> _fetchProducts({required bool activeOnly}) async {
    PostgrestFilterBuilder<List<dynamic>> query = _supabase
        .from('products')
        .select();

    if (activeOnly) {
      query = query.eq('status', 'active');
    }

    final data = await query
        .order('featured', ascending: false)
        .order('created_at', ascending: false);

    return _mapProducts(data);
  }

  List<ProductModel> _mapProducts(dynamic data) {
    if (data is! List) return [];

    return data
        .whereType<Map<String, dynamic>>()
        .map(ProductModel.fromJson)
        .toList();
  }
}
