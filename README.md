# DodgeRush

Hyper-casual one-tap endless dodge game scaffold — **Flutter + Flame**, monetized with ads/IAP **stubs**.

Working title: **DodgeRush**  
Package: `com.matza.dodge_rush`  
Core loop: tap to jump/dodge, obstacles from the right, score by time, fail → restart (~30–60s runs).

## Quick start

```bash
# Flutter stable on PATH
cd dodge_rush
flutter pub get
flutter run          # device / emulator
# or
flutter run -d chrome   # UI shell only; Flame is playable, ads disabled off-mobile
```

Android is the primary target. AdMob sample App ID is already in `android/app/src/main/AndroidManifest.xml`.

## Architecture

```
lib/
  main.dart / app.dart          # bootstrap + Riverpod overrides
  domain/                       # score & economy (no Flutter UI / Flame)
    models/player_progress.dart
    economy/economy.dart
  services/                     # ads / IAP / Hive storage
    storage_service.dart
    ads_service.dart            # STUB-safe AdMob wrapper
    iap_service.dart            # STUB-safe Play Billing wrapper
  providers/providers.dart      # Riverpod ProgressNotifier
  game/                         # Flame only — no monetization in update/render
    dodge_rush_game.dart
    components/{player,obstacle,ground}.dart
  screens/                      # Onboarding, Home, Game, Fail, Shop, Settings
  widgets/banner_ad_placeholder.dart
```

**Layers**

| Layer | Responsibility |
|--------|----------------|
| **Game** | Flame loop, collisions, spawn, score callback |
| **Domain** | Coin formulas, product IDs, progress model |
| **Services** | Hive persistence, AdMob, IAP (safe without keys) |
| **App shell** | Riverpod + Material screens / navigation |

## Screens

1. **Onboarding** — tap-to-dodge tip + Play  
2. **Home** — Play, Shop, Settings, banner slot at bottom  
3. **Game** — Flame endless runner  
4. **Fail** — score, high score, Restart, Rewarded extra life, Home  
5. **Shop** — remove-ads + 2 coin packs, balance top-right  
6. **Settings** — placeholder  

## Persistence (Hive)

Local box `player_progress` stores high score, coins, `adsRemoved`, onboarding flag, fail count. No codegen — map serialization.

## Stubs vs real monetization

### Ads (`AdsService`)

- Enabled only on Android/iOS (`main.dart`).
- Uses **Google sample** unit IDs.
- Init / load / show failures are caught — app keeps running.
- Interstitial every `Economy.interstitialEveryNFails` (3) fails.
- Rewarded: on load failure or ads disabled, stub **grants** reward so Fail UX is testable.
- Banner: visual placeholder widget (swap for real `BannerAd` when wiring production).

**To go real:** replace sample App ID + unit IDs, implement a real `BannerAd` widget, set `simulateIfUnavailable: false` paths as needed.

### IAP (`IapService`)

- Queries Play/App Store when available.
- If store unavailable (emulator without Play, desktop), **simulates** purchases and applies entitlements locally (remove-ads / coins).
- Product IDs in `Economy`.

**To go real:** create matching products in Play Console / App Store Connect; keep IDs in sync.

## Out of scope

Multiplayer, accounts, leaderboards, seasons.

## Analyze / test

```bash
flutter analyze
flutter test
```

## Zip / GitHub

Project is self-contained. After clone:

```bash
flutter pub get
flutter run
```

Do not commit `build/` or huge caches; `.dart_tool/` is gitignored by Flutter defaults.

## Web preview (GitHub Pages)

After each push to `main`, CI builds web and deploys to the `gh-pages` branch.

- Local: `flutter run -d chrome`
- Release build: `flutter build web --release --base-href /firstapp/`
- Live URL (once Pages is enabled on `gh-pages`): https://konstantinoskoufopoulos.github.io/firstapp/
