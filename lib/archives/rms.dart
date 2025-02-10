// class RMS<T> {
//   late final Injected<T> injected;

//   RMS(
//     T value, {
//     required T fromJson(Map<String, dynamic> json),
//     Map<String, dynamic> toJson(T state)?,
//     String? tag,
//   }) {
//     injected = RM.inject(
//       () => value,
//       persist: () => PersistState(
//         key: tag ?? T.toString(),
//         fromJson: (json) => fromJson(jsonDecode(json)),
//         toJson: (s) => jsonEncode(
//           toJson?.call(s) ?? (s as dynamic).toJson(),
//         ),
//       ),
//       // autoDisposeWhenNotUsed: false,
//     );
//   }
//   T get state => injected.state;
//   void put(T updated) {
//     injected
//       ..state = updated
//       ..notify();
//   }
// }
