import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/economy/economy.dart';
import '../providers/providers.dart';
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
      backgroundColor: const Color(0xFF1A237E),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              const Text(
                'Game Over',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Score: ${widget.score}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 28, color: Colors.white),
              ),
              Text(
                'High score: ${progress.highScore}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: isHigh ? Colors.amber : Colors.white70,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '+$earned coins',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.amberAccent),
              ),
              const Spacer(),
              FilledButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const GameScreen()),
                  );
                },
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: const Color(0xFF4FC3F7),
                  foregroundColor: Colors.black87,
                ),
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
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white54),
                  padding: const EdgeInsets.symmetric(vertical: 16),
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
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                    (_) => false,
                  );
                },
                child: const Text('Home', style: TextStyle(color: Colors.white70)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
