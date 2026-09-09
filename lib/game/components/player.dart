import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../theme/dodge_rush_theme.dart';
import '../dodge_rush_game.dart';
import 'obstacle.dart';

class Player extends PositionComponent
    with CollisionCallbacks, HasGameReference<DodgeRushGame> {
  Player() : super(size: Vector2(40, 40), anchor: Anchor.bottomCenter);

  static const double gravity = 1500;
  static const double jumpHeight = 136;
  static const double jumpDuration = 0.18; // easeOutCubic rise ~180ms
  static const double coyoteTime = 0.08; // 80ms
  static const double apexHang = 0.04; // 40ms at apex
  static const double landSquashDuration = 0.10; // 100ms
  static const double landSquashScale = 0.85;

  double velocityY = 0;
  bool onGround = true;
  late double groundY;

  double _coyoteTimer = 0;
  bool _rising = false;
  bool _hanging = false;
  double _hangTimer = 0;
  double _jumpT = 0;
  double _squashT = 1; // 0 = just landed (0.85), 1 = settled (1.0)
  double _scaleX = 1;
  double _scaleY = 1;

  @override
  Future<void> onLoad() async {
    groundY = game.size.y - 80;
    position = Vector2(game.size.x * 0.25, groundY);
    add(CircleHitbox(radius: 16));
  }

  void jump() {
    if (_coyoteTimer <= 0 && !onGround) return;
    onGround = false;
    _coyoteTimer = 0;
    _rising = true;
    _hanging = false;
    _hangTimer = 0;
    _jumpT = 0;
    velocityY = 0;
    // Stretch pop while rising (easeOutCubic drives Y).
    _scaleX = 0.88;
    _scaleY = 1.18;
  }

  void resetState() {
    velocityY = 0;
    onGround = true;
    _coyoteTimer = coyoteTime;
    _rising = false;
    _hanging = false;
    _hangTimer = 0;
    _jumpT = 0;
    _squashT = 1;
    _scaleX = 1;
    _scaleY = 1;
    groundY = game.size.y - 80;
    position = Vector2(game.size.x * 0.25, groundY);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (onGround) {
      _coyoteTimer = coyoteTime;
    } else if (_coyoteTimer > 0) {
      _coyoteTimer -= dt;
    }

    if (_rising) {
      _jumpT += dt;
      final t = (_jumpT / jumpDuration).clamp(0.0, 1.0);
      final h = Curves.easeOutCubic.transform(t);
      position.y = groundY - jumpHeight * h;
      // Settle stretch toward neutral during rise.
      _scaleX = 0.88 + 0.12 * t;
      _scaleY = 1.18 - 0.18 * t;
      if (t >= 1.0) {
        _rising = false;
        _hanging = true;
        _hangTimer = apexHang;
        position.y = groundY - jumpHeight;
        velocityY = 0;
      }
      return;
    }

    if (_hanging) {
      _hangTimer -= dt;
      position.y = groundY - jumpHeight;
      velocityY = 0;
      if (_hangTimer <= 0) {
        _hanging = false;
      }
      return;
    }

    if (!onGround) {
      velocityY += gravity * dt;
      position.y += velocityY * dt;
      if (position.y >= groundY) {
        _land();
      }
    } else if (_squashT < 1) {
      _squashT = (_squashT + dt / landSquashDuration).clamp(0.0, 1.0);
      final s =
          landSquashScale +
          (1 - landSquashScale) * Curves.easeOut.transform(_squashT);
      _scaleX = 2 - s; // slight widen while squashed
      _scaleY = s;
    }
  }

  void _land() {
    position.y = groundY;
    velocityY = 0;
    onGround = true;
    _coyoteTimer = coyoteTime;
    _squashT = 0;
    _scaleX = 2 - landSquashScale;
    _scaleY = landSquashScale;
  }

  @override
  void render(Canvas canvas) {
    canvas.save();
    final cx = size.x / 2;
    final cy = size.y;
    canvas.translate(cx, cy);
    canvas.scale(_scaleX, _scaleY);
    canvas.translate(-cx, -cy);

    final paint = Paint()..color = DodgeRushColors.accent;
    canvas.drawCircle(Offset(size.x / 2, size.y / 2), size.x / 2, paint);
    final slash = Paint()
      ..color = DodgeRushColors.background
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(size.x * 0.38, size.y * 0.67),
      Offset(size.x * 0.63, size.y * 0.31),
      slash,
    );
    canvas.restore();
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
