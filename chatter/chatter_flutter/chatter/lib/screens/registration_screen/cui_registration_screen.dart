import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/common/api_service/user_service.dart';
import 'package:untitled/common/controller/base_controller.dart';
import 'package:untitled/common/extensions/font_extension.dart';
import 'package:untitled/screens/extra_views/logo_tag.dart';
import 'package:untitled/screens/login_screen/register_otp_screen.dart';
import 'package:untitled/utilities/const.dart';

class CuiRegistrationScreen extends StatefulWidget {
  const CuiRegistrationScreen({Key? key}) : super(key: key);

  @override
  State<CuiRegistrationScreen> createState() => _CuiRegistrationScreenState();
}

class _CuiRegistrationScreenState extends State<CuiRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _registrationNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _batchController = TextEditingController();

  final _departments = const [
    'Computer Science',
    'Software Engineering',
    'Artificial Intelligence',
    'Cyber Security',
    'Electrical Engineering',
    'Computer Engineering',
    'Management Sciences',
    'Mathematics',
    'Physics',
    'Humanities',
  ];

  final _campuses = const [
    'COMSATS University Islamabad',
    'Islamabad',
    'Lahore',
    'Abbottabad',
    'Wah',
    'Attock',
    'Sahiwal',
    'Vehari',
  ];

  final _genders = const ['Male', 'Female', 'Other'];

  String _roleType = 'student';
  String? _department;
  String? _gender;
  String _campus = 'COMSATS University Islamabad';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _department = _departments.first;
    _gender = _genders.first;
    for (final controller in [
      _nameController,
      _registrationNumberController,
      _emailController,
      _phoneController,
      _passwordController,
      _confirmPasswordController,
      _batchController,
    ]) {
      controller.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _registrationNumberController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _batchController.dispose();
    super.dispose();
  }

  bool get _isStudent => _roleType == 'student';

  bool get _canSubmit {
    final phoneValid = RegExp(r'^(03\d{9}|\+923\d{9})$').hasMatch(_phoneController.text.trim());
    final passwordsMatch = _passwordController.text.isNotEmpty && _passwordController.text == _confirmPasswordController.text;
    final baseValid = _nameController.text.trim().isNotEmpty &&
        _emailController.text.trim().isNotEmpty &&
        _phoneController.text.trim().isNotEmpty &&
        _department != null &&
        _gender != null &&
        _passwordController.text.trim().isNotEmpty &&
        _confirmPasswordController.text.trim().isNotEmpty &&
        phoneValid &&
        passwordsMatch;

    if (_isStudent) {
      final regValid = RegExp(r'^[A-Z]{2}[0-9]{2}-[A-Z]{2,5}-[0-9]{1,4}$').hasMatch(_registrationNumberController.text.trim());
      return baseValid && regValid && _batchController.text.trim().isNotEmpty;
    }

    return baseValid;
  }

  Future<void> _sendOtp() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      BaseController.share.showSnackBar('Passwords do not match', type: SnackBarType.error);
      return;
    }

    setState(() => _isLoading = true);
    final phone = _normalizePhone(_phoneController.text);
    final response = await UserService.shared.sendRegisterOtp(phone);
    setState(() => _isLoading = false);

    if (response.status == true) {
      Get.to(() => RegisterOtpScreen(
            formData: {
              'role_type': _roleType,
              'full_name': _nameController.text.trim(),
              'registration_number': _isStudent ? _registrationNumberController.text.trim() : '',
              'email': _emailController.text.trim(),
              'department': _department ?? _departments.first,
              'phone_number': phone,
              'gender': _gender ?? _genders.first,
              'password': _passwordController.text,
              'password_confirmation': _confirmPasswordController.text,
              'batch_duration': _isStudent ? _batchController.text.trim() : '',
              'campus': _campus,
            },
          ));
    } else {
      BaseController.share.showSnackBar(response.message ?? 'Failed to send OTP', type: SnackBarType.error);
    }
  }

  String _normalizePhone(String value) {
    final phone = value.trim();
    if (phone.startsWith('+92')) {
      return '0${phone.substring(3)}';
    }
    return phone;
  }

  Widget _textField({required TextEditingController controller, required String hint, TextInputType keyboardType = TextInputType.text, bool obscure = false, String? Function(String?)? validator}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscure,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Colors.grey.shade300)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Colors.grey.shade300)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: cPrimary, width: 1.3)),
      ),
    );
  }

  Widget _dropdown({required String value, required List<String> items, required void Function(String?) onChanged, required String hint}) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Colors.grey.shade300)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Colors.grey.shade300)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: cPrimary, width: 1.3)),
      ),
    );
  }

  Widget _roleButton(String label, String value) {
    final active = _roleType == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _roleType = value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: active ? cPrimary : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: active ? cPrimary : Colors.grey.shade300),
          ),
          child: Center(
            child: Text(
              label,
              style: MyTextStyle.gilroySemiBold(color: active ? Colors.white : cBlack),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 8),
                const LogoTag(width: 120),
                const SizedBox(height: 18),
                Text('Register', textAlign: TextAlign.center, style: MyTextStyle.gilroyBold(size: 26)),
                const SizedBox(height: 10),
                Text('Create your COMSATS CUI Chatter account', textAlign: TextAlign.center, style: MyTextStyle.gilroyLight(color: cLightText, size: 15)),
                const SizedBox(height: 22),
                Row(children: [_roleButton('Student', 'student'), const SizedBox(width: 12), _roleButton('Faculty', 'faculty')]),
                const SizedBox(height: 18),
                if (_isStudent) ...[
                  _textField(controller: _nameController, hint: 'Name', validator: (v) => (v == null || v.trim().isEmpty) ? 'Name is required' : null),
                  const SizedBox(height: 12),
                  _textField(controller: _registrationNumberController, hint: 'Registration Number (FA23-BSE-130)', validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Registration number is required';
                    final valid = RegExp(r'^[A-Z]{2}[0-9]{2}-[A-Z]{2,5}-[0-9]{1,4}$').hasMatch(v.trim());
                    return valid ? null : 'Enter a valid registration number';
                  }),
                  const SizedBox(height: 12),
                  _textField(controller: _emailController, hint: 'Email', keyboardType: TextInputType.emailAddress, validator: (v) => (v == null || !GetUtils.isEmail(v.trim())) ? 'Enter a valid email' : null),
                  const SizedBox(height: 12),
                  _dropdown(value: _department!, items: _departments, onChanged: (v) => setState(() => _department = v), hint: 'Department'),
                  const SizedBox(height: 12),
                  _textField(controller: _phoneController, hint: 'Phone Number (03xxxxxxxxx or +923xxxxxxxxx)', keyboardType: TextInputType.phone, validator: (v) => (v == null || !RegExp(r'^(03\d{9}|\+923\d{9})$').hasMatch(_normalizePhone(v))) ? 'Enter a valid phone number' : null),
                  const SizedBox(height: 12),
                  _dropdown(value: _gender!, items: _genders, onChanged: (v) => setState(() => _gender = v), hint: 'Gender'),
                  const SizedBox(height: 12),
                  _textField(controller: _passwordController, hint: 'Password', obscure: true, validator: (v) => (v == null || v.length < 6) ? 'Password must be at least 6 characters' : null),
                  const SizedBox(height: 12),
                  _textField(controller: _confirmPasswordController, hint: 'Confirm Password', obscure: true, validator: (v) => v != _passwordController.text ? 'Passwords do not match' : null),
                  const SizedBox(height: 12),
                  _textField(controller: _batchController, hint: 'Batch Duration (FA23-SP27)', validator: (v) => (v == null || v.trim().isEmpty) ? 'Batch duration is required' : null),
                  const SizedBox(height: 12),
                  _dropdown(value: _campus, items: _campuses.toList(), onChanged: (v) => setState(() => _campus = v ?? _campus), hint: 'Campus'),
                ] else ...[
                  _textField(controller: _nameController, hint: 'Name', validator: (v) => (v == null || v.trim().isEmpty) ? 'Name is required' : null),
                  const SizedBox(height: 12),
                  _dropdown(value: _department!, items: _departments, onChanged: (v) => setState(() => _department = v), hint: 'Department'),
                  const SizedBox(height: 12),
                  _dropdown(value: _gender!, items: _genders, onChanged: (v) => setState(() => _gender = v), hint: 'Gender'),
                  const SizedBox(height: 12),
                  _textField(controller: _phoneController, hint: 'Phone Number (03xxxxxxxxx or +923xxxxxxxxx)', keyboardType: TextInputType.phone, validator: (v) => (v == null || !RegExp(r'^(03\d{9}|\+923\d{9})$').hasMatch(_normalizePhone(v))) ? 'Enter a valid phone number' : null),
                  const SizedBox(height: 12),
                  _textField(controller: _emailController, hint: 'Email', keyboardType: TextInputType.emailAddress, validator: (v) => (v == null || !GetUtils.isEmail(v.trim())) ? 'Enter a valid email' : null),
                  const SizedBox(height: 12),
                  _textField(controller: _passwordController, hint: 'Password', obscure: true, validator: (v) => (v == null || v.length < 6) ? 'Password must be at least 6 characters' : null),
                  const SizedBox(height: 12),
                  _textField(controller: _confirmPasswordController, hint: 'Confirm Password', obscure: true, validator: (v) => v != _passwordController.text ? 'Passwords do not match' : null),
                  const SizedBox(height: 12),
                  _dropdown(value: _campus, items: _campuses.toList(), onChanged: (v) => setState(() => _campus = v ?? _campus), hint: 'Campus'),
                ],
                const SizedBox(height: 18),
                GestureDetector(
                  onTap: _isLoading || !_canSubmit ? null : _sendOtp,
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                      color: _canSubmit ? cPrimary : cLightText.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: _isLoading
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : Text('Register', style: MyTextStyle.gilroySemiBold(color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'By registering, you agree to admin approval before account access.',
                  textAlign: TextAlign.center,
                  style: MyTextStyle.gilroyLight(color: cLightText, size: 13),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}