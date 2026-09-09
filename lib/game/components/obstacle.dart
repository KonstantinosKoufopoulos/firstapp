import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../theme/dodge_rush_theme.dart';
import '../dodge_rush_game.dart';

class Obstacle extends PositionComponent
    with HasGameReference<DodgeRushGame>, CollisionCallbacks {
  Obstacle({required Vector2 position, required this.speed})
    : super(
        position: position,
        size: Vector2(36, 56),
        anchor: Anchor.bottomCenter,
      );

  double speed;
  bool nearMissClaimed = false;
  bool hitPlayer = false;

  @override
  Future<void> onLoad() async {
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.x -= speed * dt;
    if (position.x < -size.x) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = DodgeRushColors.danger;
    canvas.drawRRect(
      RRect.fromRectAndRadius(size.toRect(), const Radius.circular(8)),
      paint,
    );
  }
}
