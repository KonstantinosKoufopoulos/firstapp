import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/providers.dart';
import '../theme/dodge_rush_theme.dart';
import '../widgets/banner_ad_placeholder.dart';
import '../widgets/dodge_rush_brand.dart';
import 'game_screen.dart';
import 'settings_screen.dart';
import 'shop_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(progressProvider);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: DodgeRushTokens.pagePadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        const DodgeRushWordmark(fontSize: 28),
                        const Spacer(),
                        _StatPill(
                          icon: Icons.monetization_on_rounded,
                          value: '${progress.coins}',
                          iconColor: DodgeRushColors.coin,
                        ),
                      ],
                    ),
                    const Spacer(),
                    const Center(child: DodgeRushMark(size: 88)),
                    const SizedBox(height: 20),
                    Center(
                      child: _StatPill(
                        icon: Icons.emoji_events_rounded,
                        value: 'High score  ${progress.highScore}',
                        iconColor: DodgeRushColors.accent,
                      ),
                    ),
                    const Spacer(),
                    _MenuButton(
                      label: 'Play',
                      icon: Icons.play_arrow_rounded,
                      primary: true,
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const GameScreen()),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    _MenuButton(
                      label: 'Shop',
                      icon: Icons.shopping_bag_rounded,
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const ShopScreen()),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    _MenuButton(
                      label: 'Settings',
                      icon: Icons.settings_rounded,
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const SettingsScreen(),
                          ),
                        );
                      },
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
            const BannerAdPlaceholder(),
          ],
        ),
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  const _StatPill({
    required this.icon,
    required this.value,
    required this.iconColor,
  });

  final IconData icon;
  final String value;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: DodgeRushColors.surface.withValues(alpha: 0.78),
        borderRadius: BorderRadius.circular(DodgeRushTokens.radius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 19, color: iconColor),
          const SizedBox(width: 7),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  const _MenuButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    this.primary = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final bool primary;

  @override
  Widget build(BuildContext context) {
    if (primary) {
      return FilledButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label),
      );
    }
    return FilledButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: FilledButton.styleFrom(
        backgroundColor: DodgeRushColors.surface,
        foregroundColor: DodgeRushColors.text,
      ),
    );
  }
}
