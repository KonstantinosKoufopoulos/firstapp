import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/economy/economy.dart';
import '../providers/providers.dart';
import '../theme/dodge_rush_theme.dart';
import 'game_screen.dart';
import 'home_screen.dart';

class FailScreen extends ConsumerStatefulWidget {
  const FailScreen({super.key, required this.score});

  final int score;

  @override
  ConsumerState<FailScreen> createState() => _FailScreenState();
}

class _FailScreenState extends ConsumerState<FailScreen> {
  bool _recorded = false;
  bool _rewardBusy = false;
  bool _extraLifeUsed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _record());
  }

  Future<void> _record() async {
    if (_recorded) return;
    _recorded = true;
    await ref.read(progressProvider.notifier).recordRun(score: widget.score);
  }

  @override
  Widget build(BuildContext context) {
    final progress = ref.watch(progressProvider);
    final earned = Economy.coinsForScore(widget.score);
    final isHigh = widget.score >= progress.highScore && widget.score > 0;

    return Scaffold(
      body: SafeArea(
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
                  borderRadius: BorderRadius.circular(DodgeRushTokens.radius),
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
                    const Text(
                      'Game Over',
                      style: TextStyle(
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
              FilledButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const GameScreen()),
                  );
                },
                child: const Text('Restart'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
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
                child: Text(
                  _rewardBusy
                      ? 'Loading ad…'
                      : _extraLifeUsed
                      ? 'Extra life used'
                      : 'Watch ad — Extra life',
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                    (_) => false,
                  );
                },
                child: const Text('Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
