import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/providers.dart';
import '../theme/dodge_rush_theme.dart';
import '../widgets/dodge_rush_brand.dart';
import 'home_screen.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _tapController;
  late final Animation<double> _tapBounce;

  @override
  void initState() {
    super.initState();
    _tapController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _tapBounce = Tween<double>(begin: 0, end: 14).animate(
      CurvedAnimation(parent: _tapController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _tapController.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    await ref.read(progressProvider.notifier).completeOnboarding();
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: DodgeRushTokens.pagePadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 40),
                  const Center(child: DodgeRushMark(size: 72)),
                  const SizedBox(height: 16),
                  const Center(child: DodgeRushWordmark(fontSize: 34)),
                  const Spacer(),
                  SizedBox(
                    height: 200,
                    child: AnimatedBuilder(
                      animation: _tapBounce,
                      builder: (context, _) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Transform.translate(
                              offset: Offset(0, _tapBounce.value),
                              child: const Icon(
                                Icons.touch_app_rounded,
                                color: DodgeRushColors.accent,
                                size: 52,
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Player stand-in under the finger.
                            Container(
                              width: 44,
                              height: 44,
                              decoration: const BoxDecoration(
                                color: DodgeRushColors.accent,
                                shape: BoxShape.circle,
                              ),
                              child: CustomPaint(
                                painter: _MiniSlashPainter(),
                              ),
                            ),
                            const SizedBox(height: 18),
                            const Text(
                              'Tap to dodge',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  const Spacer(),
                  FilledButton(
                    onPressed: _finish,
                    child: const Text('Play'),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
            Positioned(
              top: 4,
              right: 4,
              child: IconButton(
                tooltip: 'Skip',
                onPressed: _finish,
                icon: const Icon(Icons.close_rounded),
                color: DodgeRushColors.muted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniSlashPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final slash = Paint()
      ..color = DodgeRushColors.background
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(size.width * 0.35, size.height * 0.68),
      Offset(size.width * 0.65, size.height * 0.30),
      slash,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
