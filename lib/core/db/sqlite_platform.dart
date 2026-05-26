import 'package:flutter/foundation.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

bool shouldUseSqliteFfi({
  required bool isWeb,
  required TargetPlatform platform,
}) {
  return !isWeb &&
      (platform == TargetPlatform.windows || platform == TargetPlatform.linux);
}

void configureSqliteForPlatform({
  bool isWeb = kIsWeb,
  TargetPlatform? platform,
  void Function() ffiInit = sqfliteFfiInit,
  DatabaseFactory? ffiFactory,
}) {
  final targetPlatform = platform ?? defaultTargetPlatform;
  if (!shouldUseSqliteFfi(isWeb: isWeb, platform: targetPlatform)) return;

  ffiInit();
  databaseFactory = ffiFactory ?? databaseFactoryFfi;
}
