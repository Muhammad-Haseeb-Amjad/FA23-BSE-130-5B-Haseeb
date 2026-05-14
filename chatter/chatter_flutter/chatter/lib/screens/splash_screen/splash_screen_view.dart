import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/common/extensions/image_extension.dart';
import 'package:untitled/screens/splash_screen/splash_controller.dart';

// Second splash screen (Flutter-level):
// - Background: pure black
// - Logo: logo_white (207x205px PNG — high resolution, no blur)
// - The native Android splash shows a plain #00113a background before this.
class SplashScreenView extends StatelessWidget {
  const SplashScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _ = Get.put(SplashController());
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Image.asset(
          MyImages.logoWhite,
          width: 180,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
