import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled/common/api_service/user_service.dart';
import 'package:untitled/common/controller/base_controller.dart';
import 'package:untitled/common/extensions/font_extension.dart';
import 'package:untitled/screens/extra_views/logo_tag.dart';
import 'package:untitled/screens/login_screen/registration_pending_screen.dart';
import 'package:untitled/utilities/const.dart';

class RegisterOtpScreen extends StatefulWidget {
  final Map<String, dynamic> formData;

  const RegisterOtpScreen({Key? key, required this.formData}) : super(key: key);

  @override
  State<RegisterOtpScreen> createState() => _RegisterOtpScreenState();
}

class _RegisterOtpScreenState extends State<RegisterOtpScreen> {
  final _otpController = TextEditingController();
  Timer? _timer;
  int _seconds = 45;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _seconds = 45);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds <= 1) {
        timer.cancel();
      }
      if (mounted) {
        setState(() => _seconds--);
      }
    });
  }

  Future<void> _resendOtp() async {
    setState(() => _loading = true);
    final response = await UserService.shared.sendRegisterOtp(widget.formData['phone_number'] as String);
    setState(() => _loading = false);

    if (response.status == true) {
      BaseController.share.showSnackBar('OTP sent successfully', type: SnackBarType.success);
      _startTimer();
    } else {
      BaseController.share.showSnackBar(response.message ?? 'Failed to resend OTP', type: SnackBarType.error);
    }
  }

  Future<void> _verifyOtp() async {
    if (_otpController.text.trim().length != 6) {
      BaseController.share.showSnackBar('Enter a 6-digit OTP', type: SnackBarType.error);
      return;
    }

    setState(() => _loading = true);
    final phone = widget.formData['phone_number'] as String;
    final verify = await UserService.shared.verifyRegisterOtp(phone, _otpController.text.trim());

    if (verify.status != true) {
      setState(() => _loading = false);
      BaseController.share.showSnackBar(verify.message ?? 'OTP verification failed', type: SnackBarType.error);
      return;
    }

    final cardPath = widget.formData['university_card_image_path']?.toString();
    if (cardPath == null || cardPath.isEmpty || !File(cardPath).existsSync()) {
      setState(() => _loading = false);
      BaseController.share.showSnackBar('University card image is required', type: SnackBarType.error);
      return;
    }

    final register = await UserService.shared.registerCuiUserWithCard(
      roleType: widget.formData['role_type'] as String,
      fullName: widget.formData['full_name'] as String,
      email: widget.formData['email'] as String,
      phoneNumber: phone,
      department: widget.formData['department'] as String,
      gender: widget.formData['gender'] as String,
      password: widget.formData['password'] as String,
      passwordConfirmation: widget.formData['password_confirmation'] as String,
      universityCardImage: XFile(cardPath),
      registrationOtpEnabled: true,
      registrationNumber: widget.formData['registration_number']?.toString(),
      batchDuration: widget.formData['batch_duration']?.toString(),
      campus: widget.formData['campus']?.toString(),
    );

    setState(() => _loading = false);

    if (register.status == true) {
      Get.offAll(() => const RegistrationPendingScreen());
    } else {
      BaseController.share.showSnackBar(register.message ?? 'Registration failed', type: SnackBarType.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.arrow_back, color: cBlack)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10),
              const LogoTag(width: 115),
              const SizedBox(height: 24),
              Text('Verify Phone Number', textAlign: TextAlign.center, style: MyTextStyle.gilroyBold(size: 25)),
              const SizedBox(height: 10),
              Text('Enter the 6-digit code sent to ${widget.formData['phone_number']}', textAlign: TextAlign.center, style: MyTextStyle.gilroyLight(color: cLightText, size: 15)),
              const SizedBox(height: 24),
              TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                maxLength: 6,
                decoration: InputDecoration(
                  counterText: '',
                  hintText: '••••••',
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Colors.grey.shade300)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Colors.grey.shade300)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: cPrimary, width: 1.3)),
                ),
              ),
              const SizedBox(height: 18),
              GestureDetector(
                onTap: _loading ? null : _verifyOtp,
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(color: cPrimary, borderRadius: BorderRadius.circular(14)),
                  child: _loading
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : Text('Verify', style: MyTextStyle.gilroySemiBold(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: (_seconds > 0 || _loading) ? null : _resendOtp,
                child: Text(
                  _seconds > 0 ? 'Resend OTP in $_seconds s' : 'Resend OTP',
                  style: MyTextStyle.gilroySemiBold(color: _seconds > 0 ? cLightText : cPrimary),
                ),
              ),
              TextButton(
                onPressed: () => Get.back(),
                child: Text('Back', style: MyTextStyle.gilroySemiBold(color: cBlack)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}