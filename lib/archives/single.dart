// import 'dart:io';

// import 'package:manager/collection.dart';
// import 'package:manager/manager.dart';

// /// ARCHITECTURE RULES
// /// 1. each [UI] can have only on dependency on a [Bloc]
// /// 2. each [Bloc] can have multiple dependencies on [Repositories]
// /// 3. sibling dependencies between [Blocs] and [Repositories] are inhibited
// /// 4. [UI]'s can have sibling dependencies
// /// 5. each bloc should have only one [State]
// ///

// class SingletonModel<T extends Model> {
//   final String fileName;
//   final T Function(Map<String, dynamic> json) fromJson;
//   late File _file;
//   final StreamController<T?> _controller = StreamController.broadcast();

//   SingletonModel({
//     required this.fromJson,
//   }) : fileName = 'singles' {
//     _file = File(join(Model.directory, "$fileName.json"));
//     if (!_file.existsSync()) {
//       _file.writeAsStringSync(jsonEncode(null));
//     }
//     _initializeStream();
//   }

//   void _initializeStream() {
//     _controller.add(get());
//   }

//   Map<String, dynamic>? _readFileSync() {
//     if (!_file.existsSync()) return null;
//     final content = _file.readAsStringSync();
//     return content.isNotEmpty ? jsonDecode(content) : null;
//   }

//   void _writeFileSync(Map<String, dynamic>? data) {
//     _file.writeAsStringSync(jsonEncode(data));
//     _controller.add(get());
//   }

//   void put(T value) {
//     _writeFileSync(value.toJson());
//   }

//   T? get() {
//     final data = _readFileSync();
//     return data != null ? fromJson(data) : null;
//   }

//   void delete() {
//     _writeFileSync(null);
//   }

//   bool exists() {
//     return _readFileSync() != null;
//   }

//   Stream<T?> watch() => _controller.stream;
// }
