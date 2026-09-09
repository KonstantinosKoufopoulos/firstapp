import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../domain/economy/economy.dart';
import '../domain/models/player_progress.dart';
import '../services/ads_service.dart';
import '../services/iap_service.dart';
import '../services/storage_service.dart';

final storageServiceProvider = Provider<StorageService>((ref) {
  throw UnimplementedError('Override storageServiceProvider in main');
});

final adsServiceProvider = Provider<AdsService>((ref) {
  throw UnimplementedError('Override adsServiceProvider in main');
});

final iapServiceProvider = Provider<IapService>((ref) {
  throw UnimplementedError('Override iapServiceProvider in main');
});

final progressProvider =
    NotifierProvider<ProgressNotifier, PlayerProgress>(ProgressNotifier.new);

class ProgressNotifier extends Notifier<PlayerProgress> {
  StorageService get _storage => ref.read(storageServiceProvider);
  AdsService get _ads => ref.read(adsServiceProvider);
  IapService get _iap => ref.read(iapServiceProvider);

  @override
  PlayerProgress build() => _storage.load();

  Future<void> _persist(PlayerProgress next) async {
    state = next;
    await _storage.save(next);
  }

  Future<void> completeOnboarding() async {
    await _persist(state.copyWith(onboardingComplete: true));
  }

  Future<void> recordRun({
    required int score,
    bool usedExtraLife = false,
    int bonusCoins = 0,
  }) async {
    final coins = Economy.coinsForScore(score) + bonusCoins;
    final high = score > state.highScore ? score : state.highScore;
    final fails = state.failCount + 1;
    await _persist(
      state.copyWith(
        highScore: high,
        coins: state.coins + coins,
        failCount: fails,
      ),
    );
    await _ads.showInterstitialIfNeeded(
      adsRemoved: state.adsRemoved,
      everyNFails: Economy.interstitialEveryNFails,
    );
  }

  Future<bool> watchRewardedExtraLife() => _ads.showRewardedExtraLife();

  Future<void> buyRemoveAds() async {
    final result = await _iap.buy(Economy.productRemoveAds);
    // Real store: `started` only means the flow began — grant via applyPurchase.
    if (result.simulated) {
      await _persist(state.copyWith(adsRemoved: true));
    }
  }

  Future<void> buyCoinPack({required bool large}) async {
    final id = large ? Economy.productCoinsLarge : Economy.productCoinsSmall;
    final amount = large ? Economy.coinPackLarge : Economy.coinPackSmall;
    final result = await _iap.buy(id);
    // Real store: grant only from applyPurchase after verified purchase.
    if (result.simulated) {
      await _persist(state.copyWith(coins: state.coins + amount));
    }
  }

  Future<void> applyPurchase(PurchaseDetails details) async {
    final id = details.productID;
    if (id == Economy.productRemoveAds) {
      await _persist(state.copyWith(adsRemoved: true));
    } else if (id == Economy.productCoinsSmall) {
      await _persist(state.copyWith(coins: state.coins + Economy.coinPackSmall));
    } else if (id == Economy.productCoinsLarge) {
      await _persist(state.copyWith(coins: state.coins + Economy.coinPackLarge));
    }
  }
}
