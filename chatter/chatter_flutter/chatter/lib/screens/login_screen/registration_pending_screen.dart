import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/common/extensions/font_extension.dart';
import 'package:untitled/screens/extra_views/logo_tag.dart';
import 'package:untitled/screens/login_screen/login_screen.dart';
import 'package:untitled/utilities/const.dart';

class RegistrationPendingScreen extends StatelessWidget {
  const RegistrationPendingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const LogoTag(width: 120),
              const SizedBox(height: 28),
              const Icon(Icons.hourglass_top_rounded, size: 72, color: cPrimary),
              const SizedBox(height: 20),
              Text('Request Submitted', textAlign: TextAlign.center, style: MyTextStyle.gilroyBold(size: 26)),
              const SizedBox(height: 10),
              Text(
                'Your registration request has been submitted successfully. Please wait for admin approval. You will receive an email once your account is approved.',
                textAlign: TextAlign.center,
                style: MyTextStyle.gilroyLight(color: cLightText, size: 15),
              ),
              const SizedBox(height: 28),
              GestureDetector(
                onTap: () => Get.offAll(() => const LoginScreen()),
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(color: cPrimary, borderRadius: BorderRadius.circular(14)),
                  child: Text('Back to Sign In', style: MyTextStyle.gilroySemiBold(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}