import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/providers.dart';
import '../services/ads_service.dart';
import '../theme/dodge_rush_theme.dart';

/// Banner slot for Home (and menu). Shows a visual stub if ads not ready / removed.
class BannerAdPlaceholder extends ConsumerWidget {
  const BannerAdPlaceholder({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(progressProvider);
    if (progress.adsRemoved) {
      return const SizedBox.shrink();
    }
    final ads = ref.watch(adsServiceProvider);
    return Container(
      height: DodgeRushTokens.bannerSafeZone,
      width: double.infinity,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: DodgeRushColors.surface,
        border: Border(top: BorderSide(color: DodgeRushColors.background)),
      ),
      child: Text(
        ads.canShowBanner
            ? 'Banner Ad (${AdsService.bannerUnitId.split('/').last})'
            : 'Banner Ad (stub)',
        style: const TextStyle(color: DodgeRushColors.muted, fontSize: 12),
      ),
    );
  }
}
