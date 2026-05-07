import 'dart:math' as math;
import 'package:flutter/material.dart';

/// The same premium background used on the splash screen —
/// radial dark-green gradient + subtle glow + tiled 8-point star pattern.
///
/// Usage:
/// ```dart
/// Scaffold(
///   backgroundColor: Colors.transparent,
///   body: PremiumAppBackground(
///     child: SafeArea(child: ...),
///   ),
/// )
/// ```
class PremiumAppBackground extends StatelessWidget {
  final Widget child;

  const PremiumAppBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // ── Radial gradient (matches splash) ──────────────────
        Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(0, -0.3),
              radius: 1.2,
              colors: [
                Color(0xFF123D38),
                Color(0xFF0B2623),
              ],
            ),
          ),
        ),

        // ── Subtle glow at top-center ──────────────────────────
        Positioned(
          top: -60,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF55E16B).withOpacity(0.07),
                    blurRadius: 120,
                    spreadRadius: 40,
                  ),
                ],
              ),
            ),
          ),
        ),

        // ── Subtle geometric star pattern ──────────────────────
        Opacity(
          opacity: 0.03,
          child: CustomPaint(
            painter: GeometricPatternPainter(),
          ),
        ),

        // ── Content ───────────────────────────────────────────
        child,
      ],
    );
  }
}

/// Paints a tiled 8-point star geometric pattern.
/// Extracted from splash_screen.dart for reuse across all screens.
class GeometricPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    const tileSize = 60.0;
    final cols = (size.width / tileSize).ceil() + 1;
    final rows = (size.height / tileSize).ceil() + 1;

    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        final cx = col * tileSize + (row.isOdd ? tileSize / 2 : 0);
        final cy = row * tileSize;
        _drawStar(canvas, paint, Offset(cx, cy), tileSize * 0.22);
      }
    }
  }

  void _drawStar(Canvas canvas, Paint paint, Offset center, double r) {
    const points = 8;
    final path = Path();
    for (int i = 0; i < points * 2; i++) {
      final angle = (math.pi / points) * i - math.pi / 2;
      final radius = i.isEven ? r : r * 0.45;
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
