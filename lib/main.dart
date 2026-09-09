import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'providers/providers.dart';
import 'services/ads_service.dart';
import 'services/iap_service.dart';
import 'services/storage_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  final storage = await StorageService.init();

  // Ads only on Android/iOS mobile targets — avoid crash on desktop/CI.
  final adsEnabled =
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);
  final ads = AdsService(enabled: adsEnabled);
  await ads.init();

  final iap = IapService(enabled: adsEnabled);

  final container = ProviderContainer(
    overrides: [
      storageServiceProvider.overrideWithValue(storage),
      adsServiceProvider.overrideWithValue(ads),
      iapServiceProvider.overrideWithValue(iap),
    ],
  );

  await iap.init(
    onPurchase: (details) {
      container.read(progressProvider.notifier).applyPurchase(details);
    },
  );

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const DodgeRushApp(),
    ),
  );
}
