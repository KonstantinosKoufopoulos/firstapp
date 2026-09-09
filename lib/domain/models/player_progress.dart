/// Local progress persisted via Hive (no codegen — manual adapter).
class PlayerProgress {
  const PlayerProgress({
    this.highScore = 0,
    this.coins = 0,
    this.adsRemoved = false,
    this.onboardingComplete = false,
    this.failCount = 0,
  });

  final int highScore;
  final int coins;
  final bool adsRemoved;
  final bool onboardingComplete;
  final int failCount;

  PlayerProgress copyWith({
    int? highScore,
    int? coins,
    bool? adsRemoved,
    bool? onboardingComplete,
    int? failCount,
  }) {
    return PlayerProgress(
      highScore: highScore ?? this.highScore,
      coins: coins ?? this.coins,
      adsRemoved: adsRemoved ?? this.adsRemoved,
      onboardingComplete: onboardingComplete ?? this.onboardingComplete,
      failCount: failCount ?? this.failCount,
    );
  }

  Map<String, dynamic> toMap() => {
        'highScore': highScore,
        'coins': coins,
        'adsRemoved': adsRemoved,
        'onboardingComplete': onboardingComplete,
        'failCount': failCount,
      };

  factory PlayerProgress.fromMap(Map<dynamic, dynamic> map) {
    return PlayerProgress(
      highScore: (map['highScore'] as num?)?.toInt() ?? 0,
      coins: (map['coins'] as num?)?.toInt() ?? 0,
      adsRemoved: map['adsRemoved'] as bool? ?? false,
      onboardingComplete: map['onboardingComplete'] as bool? ?? false,
      failCount: (map['failCount'] as num?)?.toInt() ?? 0,
    );
  }
}
