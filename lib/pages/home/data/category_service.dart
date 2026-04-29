import 'package:hungry/pages/home/models/category_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CategoryService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<CategoryModel>> getCategories() async {
    try {
      final data = await _supabase
          .from('categories')
          .select()
          .order('created_at');

      return _mapCategories(data);
    } catch (_) {
      final data = await _supabase.from('categories').select();
      return _mapCategories(data);
    }
  }

  List<CategoryModel> _mapCategories(dynamic data) {
    if (data is! List) return [];

    return data
        .whereType<Map<String, dynamic>>()
        .map(CategoryModel.fromJson)
        .toList();
  }
}
