import 'package:package_info_plus/package_info_plus.dart';
import 'package:uuid/uuid.dart';

import 'manager.dart';

export 'dart:async';
export 'dart:convert';
export 'package:flutter/material.dart';
export 'extensions.dart';
export 'package:path/path.dart';
export 'package:states_rebuilder/states_rebuilder.dart';

import 'package:hive_flutter/hive_flutter.dart' as hive;

class HiveStorage implements IPersistStore {
  late final hive.Box box;

  @override
  Future<void> delete(String key) async => box.delete(key);

  @override
  Future<void> deleteAll() async => box.clear();

  @override
  Future<void> init() async {
    final appInfo = await PackageInfo.fromPlatform();
    await hive.Hive.initFlutter();
    box = await hive.Hive.openBox(appInfo.appName);
  }

  @override
  Object? read(String key) => box.get(key);

  @override
  Future<void> write<T>(String key, T value) async => box.put(key, value);
}

String get randomId => Uuid().v4();

abstract class Model {
  String id = randomId;
  Map<String, dynamic> toJson() {
    return {
      'id': id,
    };
  }
}

class Collection<T extends Model> {
  late final Injected<Map<String, T>> injected;
  Map<String, T> get cache => injected.state;
  set cache(Map<String, T> updated) {
    injected
      ..state = updated
      ..notify();
  }

  Collection({
    required T fromJson(Map<String, dynamic> json),
  }) {
    injected = RM.inject(
      () => {},
      persist: () => PersistState(
        key: T.toString(),
        fromJson: (json) {
          return (jsonDecode(json) as Map<String, dynamic>).map(
            (key, value) {
              return MapEntry(
                key,
                fromJson(value),
              );
            },
          );
        },
        toJson: (map) {
          return jsonEncode(
            map.map(
              (key, value) {
                return MapEntry(key, (value as dynamic).toJson());
              },
            ),
          );
        },
      ),
    );
  }

  int count() => getAll().length;
  Iterable<T> getAll() {
    final result = cache.values;
    print('getAll|$T||${result.length}');
    return result;
  }

  T? get(String id) {
    final result = cache[id];
    print("get|$id||result");
    return result;
  }

  void put(T any) {
    cache = Map.of(cache)..[any.id] = any;
    print("put|$T||${any.id}");
  }

  void remove(String id) {
    cache = Map.of(cache)..remove(id);
    print('remove|$id');
  }

  void removeAll() => cache = {};
}
