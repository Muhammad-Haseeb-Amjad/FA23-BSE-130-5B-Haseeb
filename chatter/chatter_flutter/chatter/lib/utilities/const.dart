import 'package:flutter/material.dart';

const String appName = "CUICHAT";
// IMPORTANT: Point this to the machine/IP that the phone/emulator can reach.
// Keep the trailing slash so paths resolve correctly (avoids "invalid port" errors).
// For Android physical device on same LAN: use your machine IP (10.203.17.216:8888)
// Server command: php artisan serve --host=0.0.0.0 --port=8888
const String baseURL = "https://cuichat.online/";
// Base URL for serving media files (images/videos). Use the same host/port as backend, accessible from device.
const String itemBaseURL = baseURL;
const String apiURL = "${baseURL}api/";
const String termsURL = "${baseURL}termsOfUse";
const String privacyURL = "${baseURL}privacyPolicy";
const String helpURL = "http://www.yourHelpURL.com";
const String notificationTopic = "chatter"; // Do not change it

const String revenuecatAppleApiKey = '';
const String revenuecatAndroidApiKey = '';

const String agoraAppId = 'agora_app_id';
const String agoraCustomerId = 'agora_customer_id';
const String agoraCustomerSecret = 'agora_customer_secret';

class Limits {
  static int username = 30;
  static int roomDescCount = 120;
  static int bioCount = 120;
  static int interestCount = 5;
  static int pagination = 20;
  static int storyDuration = 3;

  static int sightEngineCropSec = 5;

  static double imageSize = 720;
  static int quality = 50;
}

const List<String> storyQuickReplyEmojis = ['😂', '😮', '😍', '😢', '👏', '🔥'];
const List<int> secondsForMakingReel = [15, 30];

extension O on String {
  String addBaseURL() {
    final baseUri = Uri.parse(baseURL);

    // If already a full URL, normalize host/port for proxy and LAN access
    if (startsWith('http://') || startsWith('https://')) {
      final uri = Uri.tryParse(this);
      if (uri != null) {
        // Map localhost/127.0.0.1 to LAN IP
        final isLocalHost = uri.host == '127.0.0.1' || uri.host == 'localhost';
        final needsPortFix = uri.port == 8000;
        final needsHostFix = isLocalHost || uri.host == '192.168.100.4';

        if (needsHostFix || needsPortFix) {
          return uri
              .replace(
                scheme: uri.scheme.isNotEmpty ? uri.scheme : baseUri.scheme,
                host: needsHostFix ? baseUri.host : uri.host,
                port: needsPortFix ? baseUri.port : uri.port,
              )
              .toString();
        }
      }

      // Fallback simple replacement for stray :8000
      if (contains(':8000/')) {
        return replaceFirst(':8000/', ':8888/');
      }

      return this;
    }

    // Ensure exactly one slash between base and path
    final base = itemBaseURL.endsWith('/') ? itemBaseURL.substring(0, itemBaseURL.length - 1) : itemBaseURL;
    final path = startsWith('/') ? this : '/$this';
    return '$base$path';
  }
}

// Colors
const cPrimary = Color(0xFF40E378);
const cPulsing = Color(0xFFA1E5B3);
const cHashtagColor = Color(0xFF25CC5F);
const cWhite = Colors.white;
const cBlack = Color(0xFF0E0E0E);
const cBlackSheetBG = Color(0xFF1F1F1F);
const cMainText = Color(0xFF2d2d2d);
const cLightText = Color(0xFF979797);
const cLightIcon = Color(0xFFAEAEAE);
const cDarkText = Color(0xFF585858);
const cLightBg = Color(0xFFF1F1F1);
const cDarkBG = Color(0xFF212121);
const cBG = Color(0xFFF2F2F2);
const cGreen = Color(0xFF2CA757);
const cDarkGreen = Color(0xFF183321);
const cBlueTick = Color(0xFF1D9BF0);
const cRed = Color(0xFFFF3939);

const cAudioSpaceBG = Color(0xFF272727);
const cAudioSpaceDarkBG = Color(0xFF222222);
const cAudioSpaceLightBG = Color(0xFF3B3B3B);
const cAudioSpaceText = Color(0xFFD4D4D4);

const refreshIndicatorColor = cBlack;
const refreshIndicatorBgColor = cPrimary;

// Corner Radius-Smoothing
const cornerSmoothing = 1.0;
