import 'package:flutter/material.dart';

/// Shows a consistent, clearly visible floating snackbar.
/// [isError] uses red background; default uses green.
void showAppMessage(
  BuildContext context,
  String message, {
  bool isError = false,
}) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
      backgroundColor:
          isError ? Colors.red.shade700 : Colors.green.shade700,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 90),
      duration: const Duration(seconds: 2),
    ),
  );
}
