import 'dart:io' show Directory;

import 'package:package_info_plus/package_info_plus.dart';
import 'package:uuid/uuid.dart';
import 'manager.dart';

export 'dart:async';
export 'dart:convert';
export 'package:flutter/material.dart';
export 'collection.dart';
export 'extensions.dart';
export 'package:path/path.dart';
export 'package:states_rebuilder/states_rebuilder.dart';

import 'package:hive_flutter/hive_flutter.dart' as hive;

class HiveStorage implements IPersistStore {
  late final hive.Box box;

  @override
  Future<void> init() async {
    await hive.Hive.initFlutter();
    final appInfo = await PackageInfo.fromPlatform();
    box = await hive.Hive.openBox(appInfo.appName);
  }

  @override
  Future<void> delete(String key) async => box.delete(key);

  @override
  Future<void> deleteAll() async => box.clear();

  @override
  Object? read(String key) => box.get(key);

  @override
  Future<void> write<T>(String key, T value) async => box.put(key, value);
}

late final Directory directory;

String get randomId => Uuid().v4();
