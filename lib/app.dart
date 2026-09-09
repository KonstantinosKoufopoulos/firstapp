import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers/providers.dart';
import 'screens/home_screen.dart';
import 'screens/onboarding_screen.dart';
import 'theme/dodge_rush_theme.dart';

class DodgeRushApp extends ConsumerWidget {
  const DodgeRushApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(progressProvider);
    return MaterialApp(
      title: 'DodgeRush',
      debugShowCheckedModeBanner: false,
      theme: DodgeRushTheme.dark,
      home: progress.onboardingComplete
          ? const HomeScreen()
          : const OnboardingScreen(),
    );
  }
}
