import 'dart:math';

import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../theme/dodge_rush_theme.dart';
import 'components/ground.dart';
import 'components/obstacle.dart';
import 'components/player.dart';

/// Pure Flame gameplay — no ads/IAP in update/render.
class DodgeRushGame extends FlameGame with TapCallbacks, HasCollisionDetection {
  DodgeRushGame({this.onGameOver, this.onNearMiss});

  final void Function(int score, {required int nearMissCoins})? onGameOver;
  final void Function()? onNearMiss;

  static const hitStopMs = 60;
  static const nearMissPx = 18.0;

  late Player player;
  double _spawnTimer = 0;
  double _spawnInterval = 1.2;
  double _speed = 160;
  double _elapsed = 0;
  bool _alive = true;
  bool _hitStopping = false;
  int _patternIndex = 0;
  int _nearMissCoins = 0;
  double _nearMissFlash = 0;
  final _rng = Random();

  int get score => (_elapsed * 10).floor();
  int get nearMissCoins => _nearMissCoins;
  bool get nearMissFlashing => _nearMissFlash > 0;

  @override
  Color backgroundColor() => DodgeRushColors.background;

  @override
  Future<void> onLoad() async {
    add(Ground(size: size));
    player = Player();
    add(player);
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (_alive && !_hitStopping) {
      player.jump();
    }
  }

  double _tierSpeed() {
    if (_elapsed < 15) return 160;
    if (_elapsed < 30) return 280;
    return 340;
  }

  double _gapAfterPattern(int pattern) {
    switch (pattern) {
      case 0:
        return 1.4 + _rng.nextDouble() * 0.2; // A 1.4–1.6s
      case 1:
        return 1.25; // B
      case 2:
        return 1.2; // C
      case 3:
      default:
        return 1.8; // D pause beat
    }
  }

  void _spawnPattern() {
    final groundY = size.y - 80;
    final x = size.x + 40;
    final pattern = _patternIndex % 4;
    _speed = _tierSpeed();

    switch (pattern) {
      case 0: // A single ground
        add(Obstacle(position: Vector2(x, groundY), speed: _speed));
        break;
      case 1: // B double gap 90px
        add(Obstacle(position: Vector2(x, groundY), speed: _speed));
        add(Obstacle(position: Vector2(x + 90, groundY), speed: _speed));
        break;
      case 2: // C low + high
        add(Obstacle(position: Vector2(x, groundY), speed: _speed));
        add(Obstacle(position: Vector2(x, groundY - 128), speed: _speed));
        break;
      case 3: // D pause — no obstacles
        break;
    }

    _spawnInterval = _gapAfterPattern(pattern);
    _patternIndex++;
  }

  void _checkNearMisses() {
    for (final obstacle in children.whereType<Obstacle>()) {
      if (obstacle.nearMissClaimed || obstacle.hitPlayer) continue;
      final dx = (obstacle.position.x - player.position.x).abs();
      if (dx <= nearMissPx && obstacle.position.x <= player.position.x + 8) {
        obstacle.nearMissClaimed = true;
        _nearMissCoins += 1;
        _nearMissFlash = 0.08; // 80ms
        onNearMiss?.call();
      }
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!_alive || _hitStopping) return;

    _elapsed += dt;
    _speed = _tierSpeed();
    for (final o in children.whereType<Obstacle>()) {
      o.speed = _speed;
    }

    if (_nearMissFlash > 0) {
      _nearMissFlash = (_nearMissFlash - dt).clamp(0.0, 1.0);
    }

    _spawnTimer += dt;
    if (_spawnTimer >= _spawnInterval) {
      _spawnTimer = 0;
      _spawnPattern();
    }

    _checkNearMisses();
  }

  void onPlayerHit() {
    if (!_alive || _hitStopping) return;
    _alive = false;
    _hitStopping = true;
    for (final o in children.whereType<Obstacle>()) {
      if ((o.position.x - player.position.x).abs() < 40) {
        o.hitPlayer = true;
      }
    }
    pauseEngine();
    final finalScore = score;
    final coins = _nearMissCoins;
    Future<void>.delayed(const Duration(milliseconds: hitStopMs), () {
      _hitStopping = false;
      onGameOver?.call(finalScore, nearMissCoins: coins);
    });
  }

  void reset() {
    children.whereType<Obstacle>().toList().forEach(
      (o) => o.removeFromParent(),
    );
    _elapsed = 0;
    _spawnTimer = 0;
    _spawnInterval = 1.2;
    _speed = 160;
    _patternIndex = 0;
    _nearMissCoins = 0;
    _nearMissFlash = 0;
    _alive = true;
    _hitStopping = false;
    player.resetState();
    resumeEngine();
  }
}
