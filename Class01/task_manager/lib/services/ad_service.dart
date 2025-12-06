import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Centralized AdMob helper with real ad unit IDs
class AdService {
  AdService._internal();
  static final AdService _instance = AdService._internal();
  factory AdService() => _instance;

  InterstitialAd? _interstitialAd;
  bool _isInterstitialReady = false;

  static String get bannerAdUnitId => Platform.isAndroid
      ? 'ca-app-pub-7422859112019158/7771052495'
      : 'ca-app-pub-3940256099942544/2934735716';

  static String get interstitialAdUnitId => Platform.isAndroid
      ? 'ca-app-pub-7422859112019158/5534210897'
      : 'ca-app-pub-3940256099942544/4411468910';

  /// Initialize Google Mobile Ads SDK
  Future<void> initialize() async {
    await MobileAds.instance.initialize();
    await _loadInterstitialAd();
  }

  /// Load interstitial ad
  Future<void> _loadInterstitialAd() async {
    await InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isInterstitialReady = true;
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _isInterstitialReady = false;
              _loadInterstitialAd();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _isInterstitialReady = false;
              _loadInterstitialAd();
            },
          );
        },
        onAdFailedToLoad: (error) {
          debugPrint('Interstitial ad failed to load: $error');
          _interstitialAd = null;
          _isInterstitialReady = false;
        },
      ),
    );
  }

  /// Show an interstitial ad
  void showInterstitialAd() {
    if (_isInterstitialReady && _interstitialAd != null) {
      _interstitialAd!.show();
      _interstitialAd = null;
      _isInterstitialReady = false;
    }
  }

  /// Create and return a banner ad
  BannerAd createBannerAd({
    VoidCallback? onLoaded,
    Function(LoadAdError)? onFailed,
  }) {
    return BannerAd(
      adUnitId: bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          debugPrint('Banner ad loaded successfully');
          onLoaded?.call();
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('Banner ad failed to load: $error');
          ad.dispose();
          onFailed?.call(error);
        },
      ),
    )..load();
  }
}
