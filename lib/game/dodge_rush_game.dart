import 'dart:math';

import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'components/ground.dart';
import 'components/obstacle.dart';
import 'components/player.dart';

/// Pure Flame gameplay — no ads/IAP in update/render.
class DodgeRushGame extends FlameGame with TapCallbacks, HasCollisionDetection {
  DodgeRushGame({this.onGameOver});

  final void Function(int score)? onGameOver;

  late Player player;
  double _spawnTimer = 0;
  double _spawnInterval = 1.4;
  double _speed = 220;
  double _elapsed = 0;
  bool _alive = true;
  final _rng = Random();

  int get score => (_elapsed * 10).floor();

  @override
  Color backgroundColor() => const Color(0xFF1A237E);

  @override
  Future<void> onLoad() async {
    add(Ground(size: size));
    player = Player();
    add(player);
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (_alive) {
      player.jump();
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!_alive) return;

    _elapsed += dt;
    _speed = 220 + _elapsed * 8;
    _spawnInterval = (1.4 - _elapsed * 0.02).clamp(0.65, 1.4);

    _spawnTimer += dt;
    if (_spawnTimer >= _spawnInterval) {
      _spawnTimer = 0;
      final groundY = size.y - 80;
      // Mostly ground obstacles; occasional floating ones require timing.
      final flying = _rng.nextDouble() < 0.25;
      final y = flying ? groundY - 70 : groundY;
      add(
        Obstacle(
          position: Vector2(size.x + 40, y),
          speed: _speed,
        ),
      );
    }
  }

  void onPlayerHit() {
    if (!_alive) return;
    _alive = false;
    pauseEngine();
    onGameOver?.call(score);
  }

  void reset() {
    children.whereType<Obstacle>().toList().forEach((o) => o.removeFromParent());
    _elapsed = 0;
    _spawnTimer = 0;
    _spawnInterval = 1.4;
    _speed = 220;
    _alive = true;
    player.position = Vector2(size.x * 0.25, size.y - 80);
    player.velocityY = 0;
    player.onGround = true;
    resumeEngine();
  }
}
