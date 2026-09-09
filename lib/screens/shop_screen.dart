import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/economy/economy.dart';
import '../providers/providers.dart';

class ShopScreen extends ConsumerWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(progressProvider);
    final notifier = ref.read(progressProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFF0D47A1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: const Text('Shop'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: [
                const Icon(Icons.monetization_on, color: Colors.amber, size: 20),
                const SizedBox(width: 4),
                Text(
                  '${progress.coins}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _ShopTile(
            title: 'Remove Ads',
            subtitle: progress.adsRemoved
                ? 'Owned'
                : 'One-time purchase (${Economy.productRemoveAds})',
            icon: Icons.block,
            enabled: !progress.adsRemoved,
            onTap: () => notifier.buyRemoveAds(),
          ),
          _ShopTile(
            title: 'Coin Pack — ${Economy.coinPackSmall}',
            subtitle: 'Stub IAP (${Economy.productCoinsSmall})',
            icon: Icons.monetization_on,
            onTap: () => notifier.buyCoinPack(large: false),
          ),
          _ShopTile(
            title: 'Coin Pack — ${Economy.coinPackLarge}',
            subtitle: 'Stub IAP (${Economy.productCoinsLarge})',
            icon: Icons.savings,
            onTap: () => notifier.buyCoinPack(large: true),
          ),
          const SizedBox(height: 24),
          const Text(
            'Purchases simulate locally when the Play Store is unavailable.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white54, fontSize: 12),
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
      color: Colors.white12,
      child: ListTile(
        leading: Icon(icon, color: Colors.amber),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        subtitle: Text(subtitle, style: const TextStyle(color: Colors.white70)),
        trailing: enabled
            ? const Icon(Icons.chevron_right, color: Colors.white54)
            : const Icon(Icons.check, color: Colors.lightGreenAccent),
        onTap: enabled ? onTap : null,
      ),
    );
  }
}
