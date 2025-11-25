import 'package:flutter/material.dart';

// ------------------------------------------------------------------
// PART 1: TASBEEH CLIPPER CLASS (Neeche ki taraf curve ke liye)
// ------------------------------------------------------------------
class TasbeehClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    // In values ko adjust kar ke aap shape ki gehrai aur golai badal sakte hain
    double topRadius = size.width * 0.15; // Top corner roundness
    double bottomCurveDepth = size.height * 0.10; // Controls how much the bottom curves inwards

    // Start from Top Left
    path.moveTo(topRadius, 0);

    // Top horizontal line with round corners
    path.lineTo(size.width - topRadius, 0);
    path.quadraticBezierTo(size.width, 0, size.width, topRadius);

    // Right side (almost straight down from top to mid-height)
    path.lineTo(size.width, size.height * 0.75);

    // Right-bottom outward curve (Neeche ka hissa bahar ki taraf golai)
    path.quadraticBezierTo(size.width - (size.width * 0.02), size.height, size.width * 0.75, size.height);

    // Bottom inward curve (Neeche ki andar ki taraf golai)
    path.quadraticBezierTo(size.width * 0.5, size.height - bottomCurveDepth, size.width * 0.25, size.height);

    // Left-bottom outward curve
    path.quadraticBezierTo(size.width * 0.02, size.height, 0, size.height * 0.75);

    // Left side (almost straight up from mid-height to top)
    path.lineTo(0, topRadius);

    // Top-left corner
    path.quadraticBezierTo(0, 0, topRadius, 0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}


// ------------------------------------------------------------------
// PART 2: TASBEEH COUNTER SCREEN CLASS (No change here from previous)
// ------------------------------------------------------------------
class TasbeehCounterScreen extends StatefulWidget {
  const TasbeehCounterScreen({super.key});

  @override
  State<TasbeehCounterScreen> createState() => _TasbeehCounterScreenState();
}

class _TasbeehCounterScreenState extends State<TasbeehCounterScreen> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _resetCounter() {
    setState(() {
      _counter = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF222222),
      appBar: AppBar(
        title: const Text('Digital Tasbeeh'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: ClipPath(
          clipper: TasbeehClipper(), // Clipper is applied here
          child: Container(
            width: 200,
            height: 280,
            decoration: const BoxDecoration(
              color: Colors.black,
              boxShadow: [
                BoxShadow(
                  color: Colors.black54,
                  blurRadius: 15,
                  spreadRadius: 3,
                  offset: Offset(4, 4),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[
                // --- 1. Digital Display Screen ---
                Positioned(
                  top: 35,
                  child: Container(
                    width: 140,
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFF303030),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade700, width: 2),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      _counter.toString().padLeft(4, '0'),
                      style: const TextStyle(
                        color: Color(0xFFC8FFC8),
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'RobotoMono',
                      ),
                    ),
                  ),
                ),

                // --- 2. Large Circular Counter Button ---
                Positioned(
                  bottom: 25,
                  child: GestureDetector(
                    onTap: _incrementCounter,
                    child: Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(color: Colors.grey.shade400, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.6),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // --- 3. Smaller Reset Button (Right Side) ---
                Positioned(
                  top: 100,
                  right: 35,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: const Color(0xFF1A1A1A),
                    child: IconButton(
                      icon: const Icon(
                        Icons.refresh,
                        color: Colors.grey,
                        size: 20,
                      ),
                      onPressed: _resetCounter,
                    ),
                  ),
                ),

                // --- 4. Smaller Mode/Save Button (Left Side) ---
                Positioned(
                  top: 100,
                  left: 35,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: const Color(0xFF1A1A1A),
                    child: IconButton(
                      icon: const Icon(
                        Icons.download,
                        color: Colors.grey,
                        size: 20,
                      ),
                      onPressed: () {
                        // Logic for save/mode button
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}