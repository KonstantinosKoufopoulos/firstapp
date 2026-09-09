import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../theme/dodge_rush_theme.dart';

class Ground extends PositionComponent {
  Ground({required Vector2 size})
    : super(position: Vector2(0, size.y - 80), size: Vector2(size.x, 80));

  @override
  void render(Canvas canvas) {
    final line = Paint()
      ..color = DodgeRushColors.muted
      ..strokeWidth = 3;
    canvas.drawLine(Offset.zero, Offset(size.x, 0), line);
  }
}
