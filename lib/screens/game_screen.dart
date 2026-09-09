import 'dart:async';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../game/dodge_rush_game.dart';
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

  @override
  void initState() {
    super.initState();
    _game = DodgeRushGame(onGameOver: _handleGameOver);
    _hudTimer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      if (!mounted) return;
      final s = _game.score;
      if (s != _displayScore) {
        setState(() => _displayScore = s);
      }
    });
  }

  void _handleGameOver(int score) {
    if (_navigating || !mounted) return;
    _navigating = true;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => FailScreen(score: score)),
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
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Score: $_displayScore',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(blurRadius: 4, color: Colors.black54)],
                ),
              ),
            ),
          ),
          const Positioned(
            left: 0,
            right: 0,
            bottom: 24,
            child: Text(
              'TAP TO JUMP',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white54, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
