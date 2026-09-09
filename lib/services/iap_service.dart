import 'dart:async';
import 'dart:developer' as developer;

import 'package:in_app_purchase/in_app_purchase.dart';

import '../domain/economy/economy.dart';

/// IAP stub: queries store when available; otherwise simulates purchases.
class IapService {
  IapService({this.enabled = true});

  final bool enabled;

  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _sub;
  bool _available = false;

  final Set<String> productIds = {
    Economy.productRemoveAds,
    Economy.productCoinsSmall,
    Economy.productCoinsLarge,
  };

  Map<String, ProductDetails> products = {};

  Future<void> init({
    required void Function(PurchaseDetails details) onPurchase,
  }) async {
    if (!enabled) return;
    try {
      _available = await _iap.isAvailable();
      if (!_available) {
        developer.log('IAP store unavailable — stub mode', name: 'IapService');
        return;
      }
      _sub = _iap.purchaseStream.listen(
        (purchases) {
          for (final p in purchases) {
            onPurchase(p);
            if (p.pendingCompletePurchase) {
              _iap.completePurchase(p);
            }
          }
        },
        onError: (Object e) {
          developer.log('IAP stream error: $e', name: 'IapService');
        },
      );
      final response = await _iap.queryProductDetails(productIds);
      if (response.error != null) {
        developer.log(
          'IAP query error: ${response.error}',
          name: 'IapService',
        );
      }
      products = {for (final p in response.productDetails) p.id: p};
    } catch (e, st) {
      developer.log(
        'IAP init failed (stub continues): $e',
        name: 'IapService',
        stackTrace: st,
      );
      _available = false;
    }
  }

  Future<void> dispose() async {
    await _sub?.cancel();
  }

  /// Buy product; if store unavailable, [simulate] grants entitlement locally.
  Future<IapResult> buy(String productId, {bool simulateIfUnavailable = true}) async {
    if (_available && products.containsKey(productId)) {
      final details = products[productId]!;
      final param = PurchaseParam(productDetails: details);
      final bool ok;
      if (productId == Economy.productRemoveAds) {
        ok = await _iap.buyNonConsumable(purchaseParam: param);
      } else {
        ok = await _iap.buyConsumable(purchaseParam: param);
      }
      return IapResult(started: ok, simulated: false, productId: productId);
    }
    if (simulateIfUnavailable) {
      developer.log('Simulating IAP for $productId', name: 'IapService');
      return IapResult(started: true, simulated: true, productId: productId);
    }
    return IapResult(started: false, simulated: false, productId: productId);
  }
}

class IapResult {
  const IapResult({
    required this.started,
    required this.simulated,
    required this.productId,
  });

  final bool started;
  final bool simulated;
  final String productId;
}
