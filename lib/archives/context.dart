// // ignore_for_file: unused_element

// import 'dart:developer';

// import 'package:provider/provider.dart';

// import 'manager.dart';

// extension ContextExtensions on BuildContext {
//   T of<T>() {
//     try {
//       return watch();
//     } catch (e) {
//       if (logging) {
//         log(T.toString(), name: 'ContextExtensions');
//       }
//       return read();
//     }
//   }

//   Future<T?> push<T extends Object?>(Route<T> route) =>
//       of<NavigatorState>().push(route);

//   Future<T?> pushReplacement<T extends Object?>(Route<T> route) =>
//       of<NavigatorState>().pushReplacement(route);

//   Future<T?> pushNamed<T extends Object?, Arguments extends Object?>(
//     String routeName, [
//     Arguments? arguments,
//   ]) {
//     return of<NavigatorState>().pushNamed(routeName, arguments: arguments);
//   }

//   Future<T?> dialog<T>({
//     required Widget Function(BuildContext context) builder,
//     bool barrierDismissible = true,
//     Color? barrierColor,
//     String? barrierLabel,
//     bool useSafeArea = true,
//     bool useRootNavigator = true,
//     RouteSettings? routeSettings,
//     Offset? anchorPoint,
//     TraversalEdgeBehavior? traversalEdgeBehavior,
//   }) =>
//       showDialog(
//         context: this,
//         barrierDismissible: barrierDismissible,
//         barrierColor: barrierColor,
//         barrierLabel: barrierLabel,
//         useSafeArea: useSafeArea,
//         useRootNavigator: useRootNavigator,
//         routeSettings: routeSettings,
//         anchorPoint: anchorPoint,
//         traversalEdgeBehavior: traversalEdgeBehavior,
//         builder: (context) => builder(context),
//       );

//   Future<void> back<T extends Object?>([T? result]) async {
//     of<NavigatorState>().pop(result);
//   }

//   ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackbar(
//     SnackBar snackBar, {
//     AnimationStyle? snackBarAnimationStyle,
//   }) {
//     hideSnackBar();
//     return messenger.showSnackBar(
//       snackBar,
//       snackBarAnimationStyle: snackBarAnimationStyle,
//     );
//   }

//   void hideSnackBar({
//     SnackBarClosedReason reason = SnackBarClosedReason.hide,
//   }) =>
//       messenger.hideCurrentSnackBar(
//         reason: reason,
//       );

//   ScaffoldMessengerState get messenger => ScaffoldMessenger.of(this);

//   ScaffoldFeatureController<MaterialBanner, MaterialBannerClosedReason>
//       showBanner(MaterialBanner banner) {
//     hideBanner();
//     return messenger.showMaterialBanner(banner);
//   }

//   void hideBanner({
//     MaterialBannerClosedReason reason = MaterialBannerClosedReason.hide,
//   }) =>
//       messenger.hideCurrentMaterialBanner(
//         reason: reason,
//       );

//   Future<T?> to<T extends Object?>(Widget page) => push(
//         MaterialPageRoute(
//           builder: (context) => page,
//         ),
//       );

//   void toAndRemoveUntil(Widget page) {
//     of<NavigatorState>().pushAndRemoveUntil(
//       MaterialPageRoute(
//         builder: (context) => page,
//       ),
//       (route) => false,
//     );
//   }
// }

// Provider<T> Repository<T>(T create) => Provider<T>(create: (_) => create);
// ChangeNotifierProvider<T> Notifier<T extends ChangeNotifier>(
//   T Function(
//     BuildContext context,
//   ) create,
// ) {
//   return ChangeNotifierProvider<T>(create: create);
// }
