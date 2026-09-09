import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../dodge_rush_game.dart';
import 'obstacle.dart';

class Player extends PositionComponent
    with CollisionCallbacks, HasGameReference<DodgeRushGame> {
  Player() : super(size: Vector2(40, 40), anchor: Anchor.bottomCenter);

  static const double gravity = 1400;
  static const double jumpVelocity = -520;

  double velocityY = 0;
  bool onGround = true;
  late double groundY;

  @override
  Future<void> onLoad() async {
    groundY = game.size.y - 80;
    position = Vector2(game.size.x * 0.25, groundY);
    add(RectangleHitbox());
  }

  void jump() {
    if (onGround) {
      velocityY = jumpVelocity;
      onGround = false;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!onGround) {
      velocityY += gravity * dt;
      position.y += velocityY * dt;
      if (position.y >= groundY) {
        position.y = groundY;
        velocityY = 0;
        onGround = true;
      }
    }
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = const Color(0xFF4FC3F7);
    canvas.drawRRect(
      RRect.fromRectAndRadius(size.toRect(), const Radius.circular(6)),
      paint,
    );
    // eyes
    final eye = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(size.x * 0.7, size.y * 0.35), 4, eye);
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Obstacle) {
      game.onPlayerHit();
    }
  }
}
