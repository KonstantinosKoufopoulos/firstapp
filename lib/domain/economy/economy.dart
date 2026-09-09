/// Score / coin rules kept out of the Flame update loop.
class Economy {
  const Economy._();

  /// Coins earned for a finished run (distance-based).
  static int coinsForScore(int score) => (score / 10).floor().clamp(0, 9999);

  /// Interstitial every N fails (stub cadence).
  static const int interstitialEveryNFails = 3;

  static const int coinPackSmall = 100;
  static const int coinPackLarge = 500;

  static const String productRemoveAds = 'com.matza.dodgerush.remove_ads';
  static const String productCoinsSmall = 'com.matza.dodgerush.coins_100';
  static const String productCoinsLarge = 'com.matza.dodgerush.coins_500';
}
