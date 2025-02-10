// import 'package:objectbox/objectbox.dart';

// late Store store;
// mixin CRUD<T> {
//   /// BOX
//   Box<T> get crud => store.box<T>();

//   /// REAL-TIME
//   Stream<List<T>> watch() =>
//       query().watch(triggerImmediately: true).map(_finder);

//   /// API
//   late final put = crud.put;
//   late final putMany = crud.putMany;
//   late final putManyAsync = crud.putManyAsync;
//   late final putAsync = crud.putAsync;
//   late final remove = crud.remove;
//   late final removeAsync = crud.removeAsync;
//   late final removeAll = crud.removeAll;
//   late final count = crud.count;
//   late final query = crud.query;
//   late final get = crud.get;
//   late final getAll = crud.getAll;
//   late final getAllAsync = crud.getAllAsync;

//   /// _HELPER
//   List<T> _finder(Query<T> query) => query.find();
// }
