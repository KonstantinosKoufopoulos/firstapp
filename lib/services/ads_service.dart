import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// AdMob wrapper that never crashes without real keys.
/// Uses Google sample unit IDs; all load/show failures are swallowed.
class AdsService {
  AdsService({this.enabled = true});

  /// Set false to skip MobileAds entirely (e.g. desktop / CI).
  final bool enabled;

  bool _initialized = false;
  int _failSinceInterstitial = 0;

  /// Google sample units — replace for production.
  static const bannerUnitId = 'ca-app-pub-3940256099942544/6300978111';
  static const interstitialUnitId = 'ca-app-pub-3940256099942544/1033173712';
  static const rewardedUnitId = 'ca-app-pub-3940256099942544/5224354917';

  Future<void> init() async {
    if (!enabled || _initialized) return;
    try {
      await MobileAds.instance.initialize();
      _initialized = true;
      developer.log('AdsService initialized', name: 'AdsService');
    } catch (e, st) {
      developer.log(
        'AdsService init failed (stub continues): $e',
        name: 'AdsService',
        stackTrace: st,
      );
    }
  }

  bool get canShowBanner => enabled && _initialized;

  Future<void> showInterstitialIfNeeded({
    required bool adsRemoved,
    required int everyNFails,
  }) async {
    if (!enabled || adsRemoved || !_initialized) return;
    _failSinceInterstitial++;
    if (_failSinceInterstitial < everyNFails) return;
    _failSinceInterstitial = 0;
    try {
      await InterstitialAd.load(
        adUnitId: interstitialUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            ad.fullScreenContentCallback = FullScreenContentCallback(
              onAdDismissedFullScreenContent: (a) => a.dispose(),
              onAdFailedToShowFullScreenContent: (a, _) => a.dispose(),
            );
            ad.show();
          },
          onAdFailedToLoad: (error) {
            developer.log('Interstitial failed: $error', name: 'AdsService');
          },
        ),
      );
    } catch (e) {
      developer.log('Interstitial stub error: $e', name: 'AdsService');
    }
  }

  /// Returns true if reward was earned (or stub grants when ads off / fail).
  Future<bool> showRewardedExtraLife() async {
    if (!enabled || !_initialized) {
      if (kDebugMode) {
        developer.log('Rewarded stub grant (ads disabled)', name: 'AdsService');
      }
      return true;
    }
    final completer = Completer<bool>();
    try {
      await RewardedAd.load(
        adUnitId: rewardedUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (ad) {
            ad.fullScreenContentCallback = FullScreenContentCallback(
              onAdDismissedFullScreenContent: (a) {
                a.dispose();
                if (!completer.isCompleted) completer.complete(false);
              },
              onAdFailedToShowFullScreenContent: (a, _) {
                a.dispose();
                if (!completer.isCompleted) completer.complete(false);
              },
            );
            ad.show(
              onUserEarnedReward: (_, __) {
                if (!completer.isCompleted) completer.complete(true);
              },
            );
          },
          onAdFailedToLoad: (error) {
            developer.log('Rewarded failed: $error', name: 'AdsService');
            // Stub-friendly: still grant so Fail screen UX is testable.
            if (!completer.isCompleted) completer.complete(true);
          },
        ),
      );
    } catch (e) {
      developer.log('Rewarded stub error: $e', name: 'AdsService');
      if (!completer.isCompleted) completer.complete(true);
    }
    return completer.future.timeout(
      const Duration(seconds: 30),
      onTimeout: () => true,
    );
  }
}
