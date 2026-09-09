import 'package:dodge_rush/domain/economy/economy.dart';
import 'package:dodge_rush/domain/models/player_progress.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Economy coins scale with score', () {
    expect(Economy.coinsForScore(0), 0);
    expect(Economy.coinsForScore(99), 9);
    expect(Economy.coinsForScore(100), 10);
  });

  test('PlayerProgress round-trip map', () {
    const original = PlayerProgress(
      highScore: 42,
      coins: 7,
      adsRemoved: true,
      onboardingComplete: true,
      failCount: 3,
    );
    final restored = PlayerProgress.fromMap(original.toMap());
    expect(restored.highScore, 42);
    expect(restored.coins, 7);
    expect(restored.adsRemoved, isTrue);
    expect(restored.onboardingComplete, isTrue);
    expect(restored.failCount, 3);
  });
}
