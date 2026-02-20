import 'dart:io';
import 'package:path/path.dart' as path;

import 'package:hungry/pages/settings/data/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<UserModel?> getProfile() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return null;

    final data = await _supabase
        .from('profiles')
        .select()
        .eq('id', user.id)
        .single();

    return UserModel.fromJson(data);
  }

  Future<void> updateProfile(UserModel user) async {
    await _supabase
        .from('profiles')
        .update(user.toJson())
        .eq('id', user.userId);
  }  
  Future<void> updateProfileImage({
    required String userId,
    required String ImageUrl,
  }) async {
    await _supabase
        .from('profiles')
        .update({'image' : ImageUrl})
        .eq('id', userId);
  }

   Future<String> uploadProfileImage(File file) async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception('Not authenticated');

    final fileExt = path.extension(file.path);
    final fileName = '${user.id}$fileExt';
    final filePath = 'avatars/$fileName';

    await _supabase.storage.from('avatars').upload(
          filePath,
          file,
          fileOptions: const FileOptions(upsert: true),
        );

    final imageUrl = _supabase.storage
        .from('avatars')
        .getPublicUrl(filePath);

    return imageUrl;
  }




  
}
