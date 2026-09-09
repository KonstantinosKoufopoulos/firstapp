import 'package:flutter/material.dart';

import '../theme/dodge_rush_theme.dart';

class DodgeRushWordmark extends StatelessWidget {
  const DodgeRushWordmark({super.key, this.fontSize = 30});

  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.w900,
      letterSpacing: -1.3,
      height: 1,
    );
    return Semantics(
      label: 'DodgeRush',
      child: ExcludeSemantics(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Dodge', style: style.copyWith(color: DodgeRushColors.text)),
            ShaderMask(
              blendMode: BlendMode.srcIn,
              shaderCallback: (bounds) => const LinearGradient(
                colors: [DodgeRushColors.primary, DodgeRushColors.accent],
              ).createShader(bounds),
              child: Text('Rush', style: style.copyWith(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

/// Full mark for splash / onboarding (circle + slash).
class DodgeRushMark extends StatelessWidget {
  const DodgeRushMark({super.key, this.size = 64});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: CustomPaint(painter: DodgeRushMarkPainter()),
    );
  }
}

/// Compact slash-in-circle for in-game / menu (~32²).
class DodgeRushIcon extends StatelessWidget {
  const DodgeRushIcon({super.key, this.size = 32});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: CustomPaint(painter: DodgeRushMarkPainter()),
    );
  }
}

class DodgeRushMarkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final circle = Paint()
      ..color = DodgeRushColors.surface
      ..style = PaintingStyle.fill;
    final ring = Paint()
      ..shader = const LinearGradient(
        colors: [DodgeRushColors.primary, DodgeRushColors.accent],
      ).createShader(Offset.zero & size)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.07;
    canvas.drawCircle(center, size.width * 0.46, circle);
    canvas.drawCircle(center, size.width * 0.43, ring);

    final slash = Paint()
      ..color = DodgeRushColors.accent
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.1
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final path = Path()
      ..moveTo(size.width * 0.3, size.height * 0.63)
      ..lineTo(size.width * 0.52, size.height * 0.4)
      ..lineTo(size.width * 0.7, size.height * 0.53);
    canvas.drawPath(path, slash);

    final primarySlash = Paint()
      ..color = DodgeRushColors.primary
      ..strokeWidth = size.width * 0.08
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(size.width * 0.37, size.height * 0.72),
      Offset(size.width * 0.63, size.height * 0.26),
      primarySlash,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
