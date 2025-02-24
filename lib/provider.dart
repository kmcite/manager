import 'package:hive_flutter/hive_flutter.dart';
import 'package:manager/manager.dart';

class Provider<T> extends ChangeNotifier {
  Provider(
    this._state, {
    required this.persistance,
    this.get,
    this.set,
  }) {
    persistance.load();
    get?.call().then(
      (value) {
        state = value;
        notifyListeners();
      },
    ).catchError(
      (_) {
        state = _state;
        notifyListeners();
      },
    );
  }
  T _state;

  T get state => _state;
  set state(T state) {
    _state = state;
    set?.call(state).then(
      (_) {
        notifyListeners();
      },
    );
  }

  final Future<void> Function(T state)? set;
  final Future<T> Function()? get;
  final Persistance persistance;
}

class Persistance {
  static final _box = Hive.box('provider');

  static Future<void> initialize() async {
    await Hive.initFlutter();
    await Hive.openBox('provider');
  }

  final String key;

  const Persistance(this.key);

  String load() {
    try {
      return _box.get(key);
    } catch (e) {
      rethrow;
    }
  }

  void save(String value) async {
    await _box.put(key, value);
  }
}

extension BoolProvider on Provider<bool> {
  void toggle() => state = !state;
}
