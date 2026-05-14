import 'package:figma_squircle_updated/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/common/api_service/user_service.dart';
import 'package:untitled/common/controller/base_controller.dart';
import 'package:untitled/common/extensions/font_extension.dart';
import 'package:untitled/common/extensions/string_extension.dart';
import 'package:untitled/localization/languages.dart';
import 'package:untitled/screens/extra_views/logo_tag.dart';
import 'package:untitled/screens/registration_screen/cui_registration_screen.dart';
import 'package:untitled/screens/rooms_you_own/create_room_screen/create_room_screen.dart';
import 'package:untitled/utilities/const.dart';

class SignInWithEmailScreen extends StatefulWidget {
  final Function(String? fullName, String identity) onSubmit;

  const SignInWithEmailScreen({Key? key, required this.onSubmit}) : super(key: key);

  @override
  State<SignInWithEmailScreen> createState() => _SignInWithEmailScreenState();
}

class _SignInWithEmailScreenState extends State<SignInWithEmailScreen> with SingleTickerProviderStateMixin {
  TextEditingController emailController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  EmailSignInType type = EmailSignInType.signIn;
  BaseController baseController = BaseController();
  var height = Get.height / 40;

  @override
  void initState() {
    emailController.addListener(refresh);
    fullNameController.addListener(refresh);
    passwordController.addListener(refresh);
    confirmPasswordController.addListener(refresh);
    super.initState();
  }

  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: ClipSmoothRect(
        radius: const SmoothBorderRadius.only(topRight: SmoothRadius(cornerRadius: 12, cornerSmoothing: cornerSmoothing), topLeft: SmoothRadius(cornerRadius: 12, cornerSmoothing: cornerSmoothing)),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
            color: Colors.white,
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: GestureDetector(
                        child: const Icon(
                          Icons.close_rounded,
                          color: cBlack,
                          size: 30,
                        ),
                        onTap: () {
                          Get.back();
                        },
                      ),
                    ),
                    const Spacer()
                  ],
                ),
                Expanded(
                    child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      const LogoTag(width: 100),
                      const SizedBox(height: 40),
                      getTitle().toTextTR(MyTextStyle.gilroyBold(size: 23)),
                      const SizedBox(height: 20),
                      view(),
                      const SizedBox(height: 20),
                    ],
                  ),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget view() {
    switch (type) {
      case EmailSignInType.signIn:
        return signView();
      case EmailSignInType.signUp:
        return signUpView();
      case EmailSignInType.forgot:
        return forgotView();
      case EmailSignInType.resetOtp:
        return resetOtpView();
    }
  }

  String getTitle() {
    switch (type) {
      case EmailSignInType.signIn:
        return LKeys.signInWithEmail;
      case EmailSignInType.signUp:
        return LKeys.register;
      case EmailSignInType.forgot:
        return LKeys.forgotPassword;
      case EmailSignInType.resetOtp:
        return LKeys.forgotPassword;
    }
  }

  Widget signView() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        children: [
          MyTextField(controller: emailController, placeHolder: LKeys.email),
          const SizedBox(height: 12),
          SecureTextField(
            controller: passwordController,
            placeHolder: LKeys.password,
          ),
          EmailButton(
              text: LKeys.continue_.tr,
              isDisable: emailController.text.isEmpty || passwordController.text.isEmpty,
              onTap: () async {
                baseController.startLoading();
                try {
                  // Use Laravel/MySQL backend for email login — CUI users are
                  // stored in MySQL after admin approval, NOT in Firebase Auth.
                  final result = await UserService.shared.loginWithEmail(
                    email: emailController.text,
                    password: passwordController.text,
                    deviceToken: 'deviceToken',
                    deviceType: GetPlatform.isIOS ? 1 : 0,
                  );
                  baseController.stopLoading();
                  if (result.status == true) {
                    Get.back();
                    widget.onSubmit(
                      result.data?.fullName,
                      emailController.text,
                    );
                  } else {
                    baseController.showSnackBar(
                      result.message ?? 'Invalid email or password.',
                      type: SnackBarType.error,
                    );
                  }
                } catch (e) {
                  baseController.stopLoading();
                  baseController.showSnackBar(
                    'Network error. Please check your connection.',
                    type: SnackBarType.error,
                  );
                }
              }),
          // Responsive bottom row — use Wrap to prevent overflow on small screens
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 4,
            runSpacing: 4,
            children: [
              LKeys.doNtHaveAnAccount.toTextTR(MyTextStyle.gilroyLight(color: cLightText, size: 14)),
              GestureDetector(
                onTap: showSignUp,
                child: LKeys.signUp.toTextTR(MyTextStyle.gilroySemiBold(color: cBlack, size: 14)),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: showForgot,
                child: LKeys.forgotPassword.toTextTR(MyTextStyle.gilroySemiBold(color: cBlack, size: 14)),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget forgotView() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        children: [
          LKeys.forgotPasswordDisc.toTextTR(
            MyTextStyle.gilroyLight(color: cLightText, size: 14),
          ),
          const SizedBox(height: 10),
          MyTextField(controller: emailController, placeHolder: LKeys.email),
          EmailButton(
              text: LKeys.reset.tr,
              isDisable: emailController.text.isEmpty,
              onTap: () async {
                baseController.startLoading();
                try {
                  final result = await UserService.shared
                      .forgotPasswordRequest(emailController.text);
                  baseController.stopLoading();
                  if (result.status == true) {
                    baseController.showSnackBar(
                      result.message ?? 'OTP sent to your email.',
                      type: SnackBarType.success,
                    );
                    setState(() {
                      type = EmailSignInType.resetOtp;
                    });
                  } else {
                    baseController.showSnackBar(
                      result.message ?? 'Could not send OTP. Please try again.',
                      type: SnackBarType.error,
                    );
                  }
                } catch (e) {
                  baseController.stopLoading();
                  baseController.showSnackBar(
                    'Network error. Please check your connection.',
                    type: SnackBarType.error,
                  );
                }
              }),
          Row(
            children: [
              LKeys.iHaveAnAccount.toTextTR(MyTextStyle.gilroyLight(color: cLightText, size: 14)),
              const SizedBox(width: 5),
              GestureDetector(
                onTap: showSignIn,
                child: LKeys.signIn.toTextTR(MyTextStyle.gilroySemiBold(color: cBlack, size: 14)),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget resetOtpView() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Enter the 6-digit OTP sent to your email, then set a new password.',
            style: MyTextStyle.gilroyLight(color: cLightText, size: 14),
          ),
          const SizedBox(height: 10),
          MyTextField(controller: emailController, placeHolder: LKeys.email),
          const SizedBox(height: 12),
          MyTextField(controller: fullNameController, placeHolder: 'OTP Code'),
          const SizedBox(height: 12),
          SecureTextField(
            controller: passwordController,
            placeHolder: LKeys.password,
          ),
          const SizedBox(height: 12),
          SecureTextField(
            controller: confirmPasswordController,
            placeHolder: LKeys.confirmPassword,
          ),
          EmailButton(
              text: 'Set New Password',
              isDisable: emailController.text.isEmpty ||
                  fullNameController.text.isEmpty ||
                  passwordController.text.isEmpty ||
                  confirmPasswordController.text.isEmpty,
              onTap: () async {
                if (passwordController.text != confirmPasswordController.text) {
                  baseController.showSnackBar(
                    LKeys.passwordMismatched.tr,
                    type: SnackBarType.error,
                  );
                  return;
                }
                baseController.startLoading();
                try {
                  final result = await UserService.shared.resetPasswordRequest(
                    email: emailController.text,
                    otp: fullNameController.text,
                    password: passwordController.text,
                    passwordConfirmation: confirmPasswordController.text,
                  );
                  baseController.stopLoading();
                  if (result.status == true) {
                    baseController.showSnackBar(
                      result.message ?? 'Password reset successfully.',
                      type: SnackBarType.success,
                    );
                    setState(() {
                      type = EmailSignInType.signIn;
                      fullNameController.clear();
                      passwordController.clear();
                      confirmPasswordController.clear();
                    });
                  } else {
                    baseController.showSnackBar(
                      result.message ?? 'Could not reset password. Please try again.',
                      type: SnackBarType.error,
                    );
                  }
                } catch (e) {
                  baseController.stopLoading();
                  baseController.showSnackBar(
                    'Network error. Please check your connection.',
                    type: SnackBarType.error,
                  );
                }
              }),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    type = EmailSignInType.forgot;
                  });
                },
                child: Text(
                  'Resend OTP',
                  style: MyTextStyle.gilroySemiBold(color: cPrimary, size: 14),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: showSignIn,
                child: LKeys.signIn.toTextTR(MyTextStyle.gilroySemiBold(color: cBlack, size: 14)),
              ),
            ],
          )
        ],
      ),
    );
  }

  // signUpView is kept for reference but never shown — showSignUp() redirects
  // directly to CuiRegistrationScreen. Firebase createUserWithEmailAndPassword
  // is removed because CUI users register via Laravel/MySQL admin-approval flow.
  Widget signUpView() {
    // This view is unreachable — showSignUp() navigates to CuiRegistrationScreen.
    // Kept as a no-op to satisfy the switch statement.
    return const SizedBox.shrink();
  }

  void showSignIn() {
    setState(() {
      type = EmailSignInType.signIn;
    });
  }

  void showSignUp() {
    Get.back();
    Get.to(() => const CuiRegistrationScreen());
  }

  void showForgot() {
    setState(() {
      type = EmailSignInType.forgot;
    });
  }
}

class EmailButton extends StatelessWidget {
  final String text;
  final bool isDisable;
  final Function() onTap;

  const EmailButton({Key? key, required this.text, required this.onTap, required this.isDisable}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          if (!isDisable) {
            onTap();
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: isDisable ? cLightText.withValues(alpha: 0.4) : cPrimary,
            borderRadius: BorderRadius.circular(12),
            // boxShadow: kMyBoxShadow,
          ),
          padding: const EdgeInsets.symmetric(vertical: 15),
          margin: const EdgeInsets.only(bottom: 15, top: 15),
          alignment: Alignment.center,
          width: double.infinity,
          child: Text(
            text.tr,
            style: MyTextStyle.gilroySemiBold(),
          ),
        ));
  }
}

enum EmailSignInType { signIn, signUp, forgot, resetOtp }

class SecureTextField extends StatefulWidget {
  final String placeHolder;
  final TextEditingController controller;

  const SecureTextField({Key? key, required this.placeHolder, required this.controller}) : super(key: key);

  @override
  State<SecureTextField> createState() => _SecureTextFieldState();
}

class _SecureTextFieldState extends State<SecureTextField> {
  bool isShowPassword = true;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MyTextField(
          controller: widget.controller,
          placeHolder: widget.placeHolder,
          obscureText: isShowPassword,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          height: 45,
          child: Row(
            children: [
              const Spacer(),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isShowPassword = !isShowPassword;
                  });
                },
                child: Icon(
                  isShowPassword ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                  color: cLightText,
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
