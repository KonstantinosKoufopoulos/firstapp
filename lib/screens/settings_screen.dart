import 'package:flutter/material.dart';

import '../theme/dodge_rush_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: DodgeRushTokens.pagePadding,
        child: Center(
          child: Container(
            width: double.infinity,
            padding: DodgeRushTokens.pagePadding,
            decoration: BoxDecoration(
              color: DodgeRushColors.surface,
              borderRadius: BorderRadius.circular(DodgeRushTokens.radius),
            ),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.tune_rounded,
                  color: DodgeRushColors.primary,
                  size: 42,
                ),
                SizedBox(height: 16),
                Text(
                  'Settings placeholder',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 8),
                Text(
                  'Audio, haptics, and privacy options will land here.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: DodgeRushColors.muted, height: 1.4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
