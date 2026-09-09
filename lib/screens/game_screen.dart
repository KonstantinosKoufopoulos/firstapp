import 'dart:async';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../game/dodge_rush_game.dart';
import '../theme/dodge_rush_theme.dart';
import '../widgets/dodge_rush_brand.dart';
import 'fail_screen.dart';

class GameScreen extends ConsumerStatefulWidget {
  const GameScreen({super.key});

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> {
  late final DodgeRushGame _game;
  Timer? _hudTimer;
  int _displayScore = 0;
  bool _navigating = false;
  bool _nearMissFlash = false;

  @override
  void initState() {
    super.initState();
    _game = DodgeRushGame(
      onGameOver: _handleGameOver,
      onNearMiss: _handleNearMiss,
    );
    _hudTimer = Timer.periodic(const Duration(milliseconds: 50), (_) {
      if (!mounted) return;
      final s = _game.score;
      final flash = _game.nearMissFlashing;
      if (s != _displayScore || flash != _nearMissFlash) {
        setState(() {
          _displayScore = s;
          _nearMissFlash = flash;
        });
      }
    });
  }

  void _handleNearMiss() {
    if (!mounted) return;
    setState(() => _nearMissFlash = true);
  }

  void _handleGameOver(int score, {required int nearMissCoins}) {
    if (_navigating || !mounted) return;
    _navigating = true;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => FailScreen(score: score, nearMissCoins: nearMissCoins),
      ),
    );
  }

  @override
  void dispose() {
    _hudTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GameWidget(game: _game),
          if (_nearMissFlash)
            IgnorePointer(
              child: AnimatedOpacity(
                opacity: _nearMissFlash ? 0.35 : 0,
                duration: const Duration(milliseconds: 40),
                child: Container(color: DodgeRushColors.accent),
              ),
            ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                children: [
                  const DodgeRushIcon(size: 32),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 9,
                    ),
                    decoration: BoxDecoration(
                      color: DodgeRushColors.surface.withValues(alpha: 0.72),
                      borderRadius:
                          BorderRadius.circular(DodgeRushTokens.radius),
                    ),
                    child: Text(
                      '$_displayScore',
                      style: const TextStyle(
                        color: DodgeRushColors.text,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(width: 32),
                ],
              ),
            ),
          ),
          const Positioned(
            left: 0,
            right: 0,
            bottom: 20,
            child: Text(
              'TAP TO JUMP',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: DodgeRushColors.muted,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
