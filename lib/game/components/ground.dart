import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Ground extends PositionComponent {
  Ground({required Vector2 size})
      : super(
          position: Vector2(0, size.y - 80),
          size: Vector2(size.x, 80),
        );

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = const Color(0xFF37474F);
    canvas.drawRect(size.toRect(), paint);
    final stripe = Paint()..color = const Color(0xFF546E7A);
    for (var x = 0.0; x < size.x; x += 40) {
      canvas.drawRect(Rect.fromLTWH(x, 0, 20, 8), stripe);
    }
  }
}
