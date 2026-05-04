import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:untitled/common/api_service/notification_service.dart';
import 'package:untitled/common/api_service/user_service.dart';
import 'package:untitled/common/controller/base_controller.dart';
import 'package:untitled/common/managers/firebase_notification_manager.dart';
import 'package:untitled/common/managers/session_manager.dart';
import 'package:untitled/common/managers/subscription_manager.dart';
import 'package:untitled/screens/block_by_admin_screen/block_by_admin_screen.dart';
import 'package:untitled/screens/interests_screen/interests_screen.dart';
import 'package:untitled/screens/login_screen/sign_in_with_email_screen.dart';
import 'package:untitled/screens/profile_picture_screen/profile_picture_screen.dart';
import 'package:untitled/screens/tabbar/tabbar_screen.dart';
import 'package:untitled/screens/username_screen/username_screen.dart';
import 'package:untitled/utilities/const.dart';

class LoginController extends BaseController {
  @override
  void onReady() {
    FirebaseNotificationManager.shared;
    super.onReady();
  }

  void emailLogin() {
    Get.bottomSheet(SignInWithEmailScreen(
      onSubmit: (fullName, identity) {
        registerUser(identity: identity, loginType: LoginType.email, fullName: fullName);
      },
    ), isScrollControlled: true, ignoreSafeArea: false);
  }

  void googleLogin() async {
    try {
      // Using retrytech_plugin's GoogleSignIn wrapper
      final googleSignIn = GoogleSignIn.instance;
      await googleSignIn.initialize();
      final account = await googleSignIn.authenticate();
      
      print('Google Sign In - Email: ${account.email}, Name: ${account.displayName}');
      registerUser(
        fullName: account.displayName,
        identity: account.email,
        loginType: LoginType.google,
      );
    } catch (error) {
      log('Google Sign In Error: $error');
      showSnackBar('Google sign-in failed', type: SnackBarType.error);
    }
  }

  void appleLogin() async {
    try {
      AuthorizationCredentialAppleID value = await SignInWithApple.getAppleIDCredential(scopes: [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName]);
      registerUser(fullName: '${value.givenName ?? 'John'} ${value.familyName ?? 'Deo'}', identity: value.userIdentifier ?? '', loginType: LoginType.apple);
    } on SignInWithAppleException catch (exception) {
      log("Something wrong ${exception.toString()}");
    }
  }

  void registerUser({String? fullName, required String identity, required LoginType loginType}) {
    startLoading();
    FirebaseNotificationManager.shared.getNotificationToken((token) {
      UserService.shared.registration(
          name: fullName,
          identity: identity,
          deviceToken: token,
          loginType: loginType,
          completion: (p0) {
            var user = p0.data;
            if (p0.status != true) {
              stopLoading();
              showSnackBar(p0.message ?? 'Unable to sign in', type: SnackBarType.error);
              return;
            }

            final approvalStatus = (user?.approvalStatus ?? 'approved').toLowerCase();
            if (approvalStatus != 'approved') {
              stopLoading();
              showSnackBar(
                approvalStatus == 'pending'
                    ? 'Your account is pending admin approval.'
                    : approvalStatus == 'rejected'
                        ? 'Your registration request was rejected.'
                        : 'Your registration request was cancelled.',
                type: SnackBarType.error,
              );
              return;
            }

            SessionManager.shared.setUser(user);
            SessionManager.shared.setLogin(true);

            Widget w = InterestScreen();
            if (isPurchaseConfig) {
              Purchases.logIn('${user?.id ?? 0}');
            }
            if (user?.isPushNotifications == 1) {
              FirebaseNotificationManager.shared.subscribeToTopic(notificationTopic);
              NotificationService.shared.subscribeToAllMyRoom();
            }
            if (user?.isBlock == 1) {
              w = const BlockedByAdminScreen();
            } else if (!_hasValue(user?.interestIds)) {
              w = InterestScreen();
            } else if (!_hasValue(user?.username)) {
              w = const UserNameScreen();
            } else if (!_hasValue(user?.profile)) {
              w = const ProfilePictureScreen();
            } else {
              w = TabBarScreen();
            }
            Get.offAll(() => w);
            stopLoading();
          }).catchError((error) {
            stopLoading();
            showSnackBar('Check backend: $error', type: SnackBarType.error);
            log('Registration error: $error');
          }).timeout(
            const Duration(seconds: 15),
            onTimeout: () {
              stopLoading();
              showSnackBar('Backend not responding', type: SnackBarType.error);
            },
          );
    });
  }

  /// Returns true if the value is non-null and non-empty.
  bool _hasValue(String? value) => value != null && value.trim().isNotEmpty;
}

enum LoginType {
  google(0),
  apple(1),
  email(2);

  const LoginType(this.value);

  final int value;
}
