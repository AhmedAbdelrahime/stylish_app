import 'package:hungry/pages/home/models/offeres_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OfferService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<OfferesModel>> getOffers() async {
    final data = await _supabase.from('offers').select().order('created_at');

    return (data as List).map((item) => OfferesModel.fromJson(item)).toList();
  }
}
