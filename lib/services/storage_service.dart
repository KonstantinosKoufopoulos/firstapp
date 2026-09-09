import 'package:hive_flutter/hive_flutter.dart';

import '../domain/models/player_progress.dart';

/// Hive-backed local persistence for high score, coins, flags.
class StorageService {
  StorageService(this._box);

  static const boxName = 'player_progress';
  static const _key = 'progress';

  final Box<dynamic> _box;

  static Future<StorageService> init() async {
    await Hive.initFlutter();
    final box = await Hive.openBox<dynamic>(boxName);
    return StorageService(box);
  }

  PlayerProgress load() {
    final raw = _box.get(_key);
    if (raw is Map) {
      return PlayerProgress.fromMap(raw);
    }
    return const PlayerProgress();
  }

  Future<void> save(PlayerProgress progress) async {
    await _box.put(_key, progress.toMap());
  }
}
