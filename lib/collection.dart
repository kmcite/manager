import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:manager/manager.dart' show directory, randomId;
import 'package:path/path.dart';

abstract class Model {
  String id = randomId;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
    };
  }
}

// abstract class Collection<T extends Model> {
//   factory Collection(
//     T Function(Map<String, dynamic>) fromJson, {
//     String tag = '',
//   }) =>
//       _CollectionImpl(directory, fromJson, tag);

//   T? get(String id);
//   Stream<List<T>> watch();
//   List<T> getAll();
//   void put(T model);
//   void remove(String id);
// }

class Collection<T extends Model> {
  final File _file;
  final T Function(Map<String, dynamic> json) _fromJson;
  final Map<String, T> _storage = {};
  final StreamController<List<T>> _controller = StreamController.broadcast();
  StreamSubscription<FileSystemEvent>? _fileWatcher;

  Collection(
    this._fromJson, {
    String tag = '',
  }) : _file = File(
          join(
            directory.path,
            'collections',
            '${T.toString().toLowerCase()}s${tag.isEmpty ? '' : '_$tag'}.json',
          ),
        ) {
    _init();
  }

  void _init() {
    if (!_file.existsSync()) {
      _file.createSync(recursive: true);
      _file.writeAsStringSync('[]');
    }
    _loadCache();
    _watchFileChanges();
  }

  void _loadCache() {
    try {
      final json = _file.readAsStringSync();
      final decoded = json.isNotEmpty ? jsonDecode(json) as List : [];
      _storage.clear();
      for (var item in decoded) {
        final model = _fromJson(item);
        _storage[model.id] = model;
      }
      _emitUpdate();
    } catch (e) {
      print("Error loading cache: $e");
    }
  }

  void _saveCache() {
    try {
      _file.writeAsStringSync(
          jsonEncode(_storage.values.map((m) => m.toJson()).toList()));
    } catch (e) {
      print("Error saving to file: $e");
    }
  }

  void _emitUpdate() {
    if (!_controller.isClosed) {
      _controller.add(_storage.values.toList());
    }
  }

  void _watchFileChanges() {
    _fileWatcher?.cancel();
    _fileWatcher = _file.watch().listen((event) {
      if (event.type == FileSystemEvent.modify) {
        _loadCache();
      }
    });
  }

  @override
  T? get(String id) => _storage[id];

  @override
  List<T> getAll() => _storage.values.toList();

  @override
  void put(T model) {
    _storage[model.id] = model;
    _emitUpdate();
    _saveCache();
  }

  @override
  void remove(String id) {
    if (_storage.remove(id) != null) {
      _emitUpdate();
      _saveCache();
    }
  }

  @override
  Stream<List<T>> watch() => _controller.stream;

  void dispose() {
    _controller.close();
    _fileWatcher?.cancel();
  }
}
