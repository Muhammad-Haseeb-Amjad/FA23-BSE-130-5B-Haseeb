import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/services/connectivity_service.dart';
import '../core/services/supabase_service.dart';
import '../core/theme/app_theme.dart';
import '../widgets/offline_banner.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  bool _showPassword = false;
  bool _offline = false;
  late StreamSubscription<bool> _connSub;
  bool _useSupabase = true;

  @override
  void initState() {
    super.initState();
    _connSub = ConnectivityService.instance.connectivityStream.listen((online) {
      setState(() => _offline = !online);
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _connSub.cancel();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    // If user selects SQLite (offline) just proceed to app without Supabase auth
    if (!_useSupabase) {
      final email = _emailController.text.trim().toLowerCase();
      final pass = _passwordController.text.trim();

      final isAdmin = email == 'admin@backery.com' && (pass == 'admin@123' || pass == 'admin123');

      if (isAdmin) {
        context.go('/dashboard');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Offline login failed: invalid admin credentials')),
        );
      }
      return;
    }

    setState(() => _loading = true);
    try {
      await SupabaseService.instance.ensureInitialized();
      final res = await SupabaseService.instance.client.auth.signInWithPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      if (res.session != null) {
        if (!mounted) return;
        context.go('/dashboard');
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: ${e.toString()}')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              OfflineBanner(isOffline: _offline),
              const SizedBox(height: 20),
              Column(
                children: const [
                  CircleAvatar(radius: 32, backgroundColor: Colors.white, child: Icon(Icons.bakery_dining, color: AppColors.primary, size: 34)),
                  SizedBox(height: 10),
                  Text('BreadBox POS', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                ],
              ),
              const SizedBox(height: 30),
              Text('Welcome back, baker 👋', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 8),
              Text('Sign in to continue to your bakery workspace.', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.muted), textAlign: TextAlign.center),
              const SizedBox(height: 22),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text('Login using selected backend', style: TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      color: Colors.white,
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
                    ),
                    child: ToggleButtons(
                      isSelected: [_useSupabase, !_useSupabase],
                      borderRadius: BorderRadius.circular(20),
                      fillColor: AppColors.primary,
                      selectedColor: Colors.white,
                      color: AppColors.accent,
                      constraints: const BoxConstraints(minWidth: 120, minHeight: 42),
                      children: const [
                        Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Text('Supabase')),
                        Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Text('SQLite (Offline)')),
                      ],
                      onPressed: (index) => setState(() => _useSupabase = index == 0),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email_outlined)),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Email required';
                        if (!value.contains('@')) return 'Enter a valid email';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: !_showPassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(_showPassword ? Icons.visibility_off : Icons.visibility, color: AppColors.muted),
                          onPressed: () => setState(() => _showPassword = !_showPassword),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Password required';
                        if (value.length < 6) return 'Min 6 characters';
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Password reset flow coming soon.')),
                        ),
                        child: const Text('Forgot Password?'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _loading ? null : _login,
                        child: _loading
                            ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                            : const Text('Login'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 4)),
                  ],
                ),
                child: Row(
                  children: const [
                    Icon(Icons.info_outline, color: AppColors.primary),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Use your Supabase-authenticated email and password. Roles are loaded from user metadata.',
                        style: TextStyle(color: AppColors.accent),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
