import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/economy/economy.dart';
import '../providers/providers.dart';
import '../theme/dodge_rush_theme.dart';
import 'game_screen.dart';
import 'home_screen.dart';

class FailScreen extends ConsumerStatefulWidget {
  const FailScreen({super.key, required this.score, this.nearMissCoins = 0});

  final int score;
  final int nearMissCoins;

  @override
  ConsumerState<FailScreen> createState() => _FailScreenState();
}

class _FailScreenState extends ConsumerState<FailScreen>
    with SingleTickerProviderStateMixin {
  bool _recorded = false;
  bool _rewardBusy = false;
  bool _extraLifeUsed = false;
  bool _showFlash = true;
  bool _showPanel = false;
  late final AnimationController _slideController;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    WidgetsBinding.instance.addPostFrameCallback((_) => _startFailSequence());
  }

  Future<void> _startFailSequence() async {
    HapticFeedback.lightImpact();
    await _record();
    if (!mounted) return;
    // Full-screen danger flash 80ms → panel slide-up.
    await Future<void>.delayed(const Duration(milliseconds: 80));
    if (!mounted) return;
    setState(() {
      _showFlash = false;
      _showPanel = true;
    });
    _slideController.forward();
  }

  Future<void> _record() async {
    if (_recorded) return;
    _recorded = true;
    await ref.read(progressProvider.notifier).recordRun(
      score: widget.score,
      bonusCoins: widget.nearMissCoins,
    );
  }

  static const _failCopy = [
    'Almost!',
    'So close!',
    'One more',
    'Nice try',
  ];

  String get _retryCopy {
    // Rotate by fail count so consecutive deaths feel different.
    final fails = ref.read(progressProvider).failCount;
    return _failCopy[fails % _failCopy.length];
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = ref.watch(progressProvider);
    final earned = Economy.coinsForScore(widget.score) + widget.nearMissCoins;
    final isHigh = widget.score >= progress.highScore && widget.score > 0;

    return Scaffold(
      backgroundColor: DodgeRushColors.background,
      body: Stack(
        children: [
          if (_showPanel)
            SafeArea(
              child: SlideTransition(
                position: _slideAnimation,
                child: Padding(
                  padding: DodgeRushTokens.pagePadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Spacer(),
                      Container(
                        padding: DodgeRushTokens.pagePadding,
                        decoration: BoxDecoration(
                          color: DodgeRushColors.surface,
                          borderRadius:
                              BorderRadius.circular(DodgeRushTokens.radius),
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: 54,
                              height: 54,
                              decoration: const BoxDecoration(
                                color: DodgeRushColors.danger,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.close_rounded, size: 34),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              _retryCopy,
                              style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              '${widget.score}',
                              style: const TextStyle(
                                fontSize: 42,
                                fontWeight: FontWeight.w900,
                                height: 1,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'SCORE',
                              style: TextStyle(
                                color: DodgeRushColors.muted,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.5,
                              ),
                            ),
                            const SizedBox(height: 18),
                            Text(
                              'High score  ${progress.highScore}',
                              style: TextStyle(
                                color: isHigh
                                    ? DodgeRushColors.coin
                                    : DodgeRushColors.muted,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '+$earned coins',
                              style: const TextStyle(
                                color: DodgeRushColors.coin,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      // Extra life CTA = accent style
                      FilledButton(
                        onPressed: _extraLifeUsed || _rewardBusy
                            ? null
                            : () async {
                                setState(() => _rewardBusy = true);
                                final ok = await ref
                                    .read(progressProvider.notifier)
                                    .watchRewardedExtraLife();
                                if (!context.mounted) return;
                                setState(() {
                                  _rewardBusy = false;
                                  if (ok) _extraLifeUsed = true;
                                });
                                if (ok) {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (_) => const GameScreen(),
                                    ),
                                  );
                                }
                              },
                        style: FilledButton.styleFrom(
                          backgroundColor: DodgeRushColors.accent,
                          foregroundColor: DodgeRushColors.background,
                          disabledBackgroundColor:
                              DodgeRushColors.surface,
                          disabledForegroundColor: DodgeRushColors.muted,
                        ),
                        child: Text(
                          _rewardBusy
                              ? 'Loading ad…'
                              : _extraLifeUsed
                                  ? 'Extra life used'
                                  : 'Watch ad — Extra life',
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Restart = muted
                      FilledButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) => const GameScreen(),
                            ),
                          );
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: DodgeRushColors.surface,
                          foregroundColor: DodgeRushColors.muted,
                        ),
                        child: const Text('Restart'),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (_) => const HomeScreen(),
                            ),
                            (_) => false,
                          );
                        },
                        child: const Text('Home'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          if (_showFlash)
            const Positioned.fill(
              child: ColoredBox(color: DodgeRushColors.danger),
            ),
        ],
      ),
    );
  }
}
