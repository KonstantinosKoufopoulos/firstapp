import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/providers.dart';
import '../theme/dodge_rush_theme.dart';
import '../widgets/dodge_rush_brand.dart';
import 'home_screen.dart';

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: DodgeRushTokens.pagePadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              const Center(child: DodgeRushMark(size: 84)),
              const SizedBox(height: 20),
              const Center(child: DodgeRushWordmark(fontSize: 38)),
              const SizedBox(height: 28),
              Container(
                padding: DodgeRushTokens.pagePadding,
                decoration: BoxDecoration(
                  color: DodgeRushColors.surface,
                  borderRadius: BorderRadius.circular(DodgeRushTokens.radius),
                ),
                child: const Column(
                  children: [
                    Icon(
                      Icons.touch_app_rounded,
                      color: DodgeRushColors.accent,
                      size: 46,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Tap to jump / dodge',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Obstacles come from the right.\nSurvive as long as you can.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: DodgeRushColors.muted,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              FilledButton(
                onPressed: () async {
                  await ref
                      .read(progressProvider.notifier)
                      .completeOnboarding();
                  if (!context.mounted) return;
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                  );
                },
                child: const Text('Play'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
