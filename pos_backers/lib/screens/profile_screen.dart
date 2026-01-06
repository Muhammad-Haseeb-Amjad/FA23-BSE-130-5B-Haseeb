import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/services/supabase_service.dart';
import '../core/services/local_database_service.dart';
import '../core/services/connectivity_service.dart';
import '../core/theme/app_theme.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? _avatarPath;
  bool _online = true;
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final online = await ConnectivityService.instance.isOnline;
    _online = online;

    // Get logged-in user ID
    String? userId;
    try {
      await SupabaseService.instance.ensureInitialized();
      userId = SupabaseService.instance.client.auth.currentUser?.id;
    } catch (e) {
      print('Failed to get user ID: $e');
    }

    if (userId == null) {
      userId = 'default';
    }

    // Try Supabase first when online
    if (online) {
      try {
        await SupabaseService.instance.ensureInitialized();
        final res = await SupabaseService.instance.client.from('profiles').select().eq('id', userId).limit(1);
        if (res != null && res.isNotEmpty) {
          final row = Map<String, dynamic>.from(res.first);
          await _cacheLocal(row);
          _applyProfile(row);
          return;
        }
      } catch (e) {
        print('Profile fetch from Supabase failed: $e');
      }
    }

    // Fallback to local DB
    final db = await LocalDatabaseService.instance.database;
    final local = await db.query('profile', where: 'id = ?', whereArgs: [userId]);
    if (local.isNotEmpty) {
      _applyProfile(local.first);
      return;
    }

    // Fallback to shared prefs legacy
    final prefs = await SharedPreferences.getInstance();
    final avatar = prefs.getString('profile_avatar_path');
    final name = prefs.getString('store_name') ?? 'Golden Crust Bakery';
    final emailPref = prefs.getString('store_email') ?? '';
    _applyProfile({
      'name': name,
      'email': emailPref.isNotEmpty ? emailPref : await SupabaseService.instance.getCurrentUserEmail() ?? 'contact@goldencrust.com',
      'address': prefs.getString('store_address') ?? '',
      'phone': prefs.getString('store_phone') ?? '',
      'image_path': avatar,
    });
  }

  void _applyProfile(Map<String, dynamic> row) {
    if (!mounted) return;
    setState(() {
      _avatarPath = row['image_path'] as String?;
      _nameController.text = (row['name'] ?? '').toString();
      _addressController.text = (row['address'] ?? '').toString();
      _phoneController.text = (row['phone'] ?? '').toString();
      _emailController.text = (row['email'] ?? '').toString();
    });
  }

  Future<void> _cacheLocal(Map<String, dynamic> row) async {
    final data = {
      'id': row['id'] ?? 'default',
      'name': row['name'],
      'address': row['address'],
      'phone': row['phone'],
      'email': row['email'],
      'image_path': row['image_path'],
      'updated_at': row['updated_at'] ?? DateTime.now().toIso8601String(),
    };
    await LocalDatabaseService.instance.insert('profile', data, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> _pickAvatar() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    final path = result?.files.single.path;
    if (path == null) return;
    // Copy to app documents so it persists across sessions/logouts
    try {
      final docs = await getApplicationDocumentsDirectory();
      final target = File('${docs.path}/profile_avatar.png');
      await File(path).copy(target.path);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('profile_avatar_path', target.path);
      if (!mounted) return;
      setState(() => _avatarPath = target.path);
      return;
    } catch (_) {
      // fallback to original path if copy fails
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_avatar_path', path);
    if (!mounted) return;
    setState(() => _avatarPath = path);
  }

  Future<void> _saveProfile() async {
    // Get logged-in user ID
    String? id;
    try {
      await SupabaseService.instance.ensureInitialized();
      id = SupabaseService.instance.client.auth.currentUser?.id;
    } catch (e) {
      print('Failed to get user ID: $e');
    }

    if (id == null) {
      id = 'default';
    }

    String? uploadedUrl;

    // Upload avatar if needed and online
    if (_online && _avatarPath != null && !_avatarPath!.startsWith('http')) {
      uploadedUrl = await _uploadAvatarToSupabase(_avatarPath!, id);
      if (uploadedUrl != null) {
        setState(() => _avatarPath = uploadedUrl);
      }
    }

    final payload = {
      'id': id,
      'name': _nameController.text.trim(),
      'address': _addressController.text.trim(),
      'phone': _phoneController.text.trim(),
      'email': _emailController.text.trim(),
      'image_path': uploadedUrl ?? _avatarPath,
      'updated_at': DateTime.now().toIso8601String(),
    };

    // Save locally
    await LocalDatabaseService.instance.insert('profile', payload, conflictAlgorithm: ConflictAlgorithm.replace);

    // Save to Supabase
    if (_online) {
      try {
        await SupabaseService.instance.ensureInitialized();
        await SupabaseService.instance.client.from('profiles').upsert(payload, onConflict: 'id');
      } catch (e) {
        print('Profile upsert failed: $e');
      }
    }

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully'), duration: Duration(seconds: 2)),
    );
  }

  Future<String?> _uploadAvatarToSupabase(String path, String id) async {
    try {
      final file = File(path);
      if (!file.existsSync()) return null;
      final ext = path.split('.').last;
      final storagePath = 'profiles/$id.$ext';
      final storage = SupabaseService.instance.client.storage.from('profile-avatars');
      await storage.upload(storagePath, file, fileOptions: const FileOptions(upsert: true));
      final url = storage.getPublicUrl(storagePath);
      return url;
    } catch (e) {
      print('Avatar upload failed: $e');
      return null;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Edit Profile'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: GestureDetector(
              onTap: _pickAvatar,
              child: Stack(
                children: [
                    CircleAvatar(
                    radius: 56,
                    backgroundColor: Colors.white,
                    backgroundImage: _avatarPath == null
                      ? null
                      : _avatarPath!.startsWith('http')
                        ? NetworkImage(_avatarPath!)
                        : (File(_avatarPath!).existsSync() ? FileImage(File(_avatarPath!)) as ImageProvider : null),
                    child: _avatarPath == null
                      ? const Icon(Icons.person, color: AppColors.primary, size: 56)
                      : (_avatarPath!.startsWith('http') || File(_avatarPath!).existsSync())
                        ? null
                        : const Icon(Icons.person, color: AppColors.primary, size: 56),
                    ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: AppColors.primary.withOpacity(0.35), blurRadius: 8, offset: const Offset(0, 3)),
                        ],
                      ),
                      child: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              'Change Logo',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Bakery Name',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              hintText: 'Enter bakery name',
              prefixIcon: const Icon(Icons.storefront, color: AppColors.primary),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Address',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _addressController,
            decoration: InputDecoration(
              hintText: 'Enter address',
              prefixIcon: const Icon(Icons.location_on, color: AppColors.primary),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 16),
          const Text(
            'Phone Number',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _phoneController,
            decoration: InputDecoration(
              hintText: 'Enter phone number',
              prefixIcon: const Icon(Icons.phone, color: AppColors.primary),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Email Address',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _emailController,
            readOnly: true,
            decoration: InputDecoration(
              hintText: 'Enter email address',
              prefixIcon: const Icon(Icons.email, color: AppColors.primary),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _saveProfile,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: const Text('Save Changes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}
