import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/economy/economy.dart';
import '../providers/providers.dart';
import '../theme/dodge_rush_theme.dart';

class ShopScreen extends ConsumerWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(progressProvider);
    final notifier = ref.read(progressProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: DodgeRushTokens.padding),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: DodgeRushColors.surface.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(DodgeRushTokens.radius),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.monetization_on_rounded,
                    color: DodgeRushColors.coin,
                    size: 20,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    '${progress.coins}',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: DodgeRushTokens.pagePadding,
        children: [
          _ShopTile(
            title: 'Remove Ads',
            subtitle: progress.adsRemoved
                ? 'Owned'
                : 'One-time purchase (${Economy.productRemoveAds})',
            icon: Icons.block_rounded,
            enabled: !progress.adsRemoved,
            onTap: () => notifier.buyRemoveAds(),
          ),
          _ShopTile(
            title: 'Coin Pack — ${Economy.coinPackSmall}',
            subtitle: 'Stub IAP (${Economy.productCoinsSmall})',
            icon: Icons.monetization_on_rounded,
            onTap: () => notifier.buyCoinPack(large: false),
          ),
          _ShopTile(
            title: 'Coin Pack — ${Economy.coinPackLarge}',
            subtitle: 'Stub IAP (${Economy.productCoinsLarge})',
            icon: Icons.savings_rounded,
            onTap: () => notifier.buyCoinPack(large: true),
          ),
          const SizedBox(height: 12),
          const Text(
            'Purchases simulate locally when the Play Store is unavailable.',
            textAlign: TextAlign.center,
            style: TextStyle(color: DodgeRushColors.muted, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _ShopTile extends StatelessWidget {
  const _ShopTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    this.enabled = true,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: DodgeRushColors.coin.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: DodgeRushColors.coin),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: DodgeRushColors.muted),
        ),
        trailing: enabled
            ? const Icon(
                Icons.chevron_right_rounded,
                color: DodgeRushColors.muted,
              )
            : const Icon(Icons.check_rounded, color: DodgeRushColors.accent),
        onTap: enabled ? onTap : null,
      ),
    );
  }
}
