import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  SupabaseService._();
  static final SupabaseService instance = SupabaseService._();

  bool _initialized = false;
  bool get isInitialized => _initialized;

  Future<void> init() async {
    final url = dotenv.env['SUPABASE_URL'];
    final anonKey = dotenv.env['SUPABASE_ANON_KEY'];
    if (url == null || anonKey == null || url.isEmpty || anonKey.isEmpty) {
      throw Exception('Supabase credentials are missing. Add SUPABASE_URL and SUPABASE_ANON_KEY to your .env');
    }
    // Guard against placeholder values that will fail DNS resolution
    final lowerUrl = url.toLowerCase();
    if (lowerUrl.contains('your-project') || lowerUrl.contains('your-project-id') || anonKey.contains('YOUR-ANON-KEY')) {
      throw Exception('Supabase credentials in .env are placeholders. Replace with your real Project URL and anon public key from Supabase Settings > API.');
    }
    await Supabase.initialize(url: url, anonKey: anonKey);
    _initialized = true;
  }

  Future<void> ensureInitialized() async {
    if (!_initialized) {
      await init();
    }
  }

  SupabaseClient get client => Supabase.instance.client;

  Future<String?> getCurrentUserEmail() async {
    try {
      await ensureInitialized();
      return client.auth.currentUser?.email;
    } catch (e) {
      print('Error getting current user email: $e');
      return null;
    }
  }
}
