import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

class OfflineBanner extends StatelessWidget {
  final bool isOffline;
  const OfflineBanner({super.key, required this.isOffline});

  @override
  Widget build(BuildContext context) {
    if (!isOffline) return const SizedBox.shrink();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
      color: Colors.red.shade50,
      child: Row(
        children: const [
          Icon(Icons.wifi_off, color: AppColors.danger, size: 18),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Offline mode: sales will sync when connection restores.',
              style: TextStyle(color: AppColors.danger, fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
