import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/providers.dart';
import '../services/ads_service.dart';

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
      height: 50,
      width: double.infinity,
      alignment: Alignment.center,
      color: const Color(0xFF263238),
      child: Text(
        ads.canShowBanner
            ? 'Banner Ad (${AdsService.bannerUnitId.split('/').last})'
            : 'Banner Ad (stub)',
        style: const TextStyle(color: Colors.white70, fontSize: 12),
      ),
    );
  }
}
