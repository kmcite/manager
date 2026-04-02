import 'package:flutter/material.dart' hide Router;

final instances = <Type, ChangeNotifier>{};

@deprecated
void put<T extends ChangeNotifier>(T instance) {
  instances[T] = instance;
}

T find<T extends ChangeNotifier>([T? instance]) {
  if (instance != null) {
    instances[T] = instance;
  }
  return instances[T] as T? ?? (throw Exception('$T not found'));
}
