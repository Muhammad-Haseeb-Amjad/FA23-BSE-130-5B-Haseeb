import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/services/connectivity_service.dart';
import '../core/services/supabase_service.dart';
import '../core/theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late StreamSubscription<bool> _connSub;
  bool _online = true;

  @override
  void initState() {
    super.initState();
    _connSub = ConnectivityService.instance.connectivityStream.listen((online) {
      setState(() => _online = online);
    });
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    try {
      await SupabaseService.instance.ensureInitialized();
      await Future.delayed(const Duration(milliseconds: 1200));
      final session = SupabaseService.instance.client.auth.currentSession;
      if (!mounted) return;
      if (session == null) {
        context.go('/login');
      } else {
        context.go('/dashboard');
      }
    } catch (e) {
      print('Bootstrap error: $e');
      if (mounted) {
        // Route to login; login will also guard init and show message
        context.go('/login');
      }
    }
  }

  @override
  void dispose() {
    _connSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.bakery_dining, size: 56, color: AppColors.primary),
                      SizedBox(height: 10),
                      Text('BreadBox', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const SizedBox(height: 12),
              const CircularProgressIndicator(color: AppColors.primary),
              const SizedBox(height: 12),
              Text(_online ? 'Checking session…' : 'Offline mode enabled', style: Theme.of(context).textTheme.bodyMedium),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
