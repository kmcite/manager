import 'package:flutter/material.dart';
import 'package:manager/model.dart';

abstract class Collection<M extends Model> extends ChangeNotifier {
  final cache = <int, M>{};

  M? get(int id) => cache[id];
  List<M> getAll() => cache.values.toList();
  void put(M model) {
    cache[model.id] = model;
    notifyListeners();
  }

  void remove(int id) {
    cache.remove(id);
    notifyListeners();
  }

  void removeAll() {
    cache.clear();
    notifyListeners();
  }
}
