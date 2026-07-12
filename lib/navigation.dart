part of 'manager.dart';

extension NavigationContext on BuildContext {
  NavigatorState get navigator => Navigator.of(this);

  // ---------------------------------------------------------------------------
  // Push
  // ---------------------------------------------------------------------------

  Future<T?> push<T>(Widget page) {
    return navigator.push<T>(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  Future<T?> pushRoute<T>(Route<T> route) {
    return navigator.push(route);
  }

  Future<T?> pushNamed<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) {
    return navigator.pushNamed<T>(
      routeName,
      arguments: arguments,
    );
  }

  // ---------------------------------------------------------------------------
  // Replace
  // ---------------------------------------------------------------------------

  Future<T?> replace<T, TO>(
    Widget page, {
    TO? result,
  }) {
    return navigator.pushReplacement<T, TO>(
      MaterialPageRoute(builder: (_) => page),
      result: result,
    );
  }

  Future<T?> replaceNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    Object? arguments,
    TO? result,
  }) {
    return navigator.pushReplacementNamed<T, TO>(
      routeName,
      arguments: arguments,
      result: result,
    );
  }

  Future<T?> clearAndPush<T>(Widget page) {
    return navigator.pushAndRemoveUntil<T>(
      MaterialPageRoute(builder: (_) => page),
      (_) => false,
    );
  }

  Future<T?> clearAndPushNamed<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) {
    return navigator.pushNamedAndRemoveUntil<T>(
      routeName,
      (_) => false,
      arguments: arguments,
    );
  }

  // ---------------------------------------------------------------------------
  // Pop
  // ---------------------------------------------------------------------------

  void pop<T extends Object?>([T? result]) {
    navigator.pop(result);
  }

  Future<bool> maybePop<T extends Object?>([T? result]) {
    return navigator.maybePop(result);
  }

  bool get canPop => navigator.canPop();

  void popUntil(RoutePredicate predicate) {
    navigator.popUntil(predicate);
  }

  void popToRoot() {
    navigator.popUntil((route) => route.isFirst);
  }

  // ---------------------------------------------------------------------------
  // Dialogs
  // ---------------------------------------------------------------------------

  Future<T?> pushDialog<T>(
    Widget child, {
    bool barrierDismissible = true,
    Color? barrierColor,
    bool useRootNavigator = true,
    RouteSettings? routeSettings,
  }) {
    return showDialog<T>(
      context: this,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      useRootNavigator: useRootNavigator,
      routeSettings: routeSettings,
      builder: (_) => child,
    );
  }

  Future<T?> pushAdaptiveDialog<T>({
    required Widget child,
    bool barrierDismissible = true,
    bool useRootNavigator = true,
    RouteSettings? routeSettings,
  }) {
    return showAdaptiveDialog<T>(
      context: this,
      barrierDismissible: barrierDismissible,
      useRootNavigator: useRootNavigator,
      routeSettings: routeSettings,
      builder: (_) => child,
    );
  }

  // ---------------------------------------------------------------------------
  // Bottom Sheets
  // ---------------------------------------------------------------------------

  Future<T?> pushBottomSheet<T>(
    Widget child, {
    bool isDismissible = true,
    bool enableDrag = true,
    bool isScrollControlled = true,
    bool useSafeArea = true,
    Color? backgroundColor,
    ShapeBorder? shape,
    Clip? clipBehavior,
  }) {
    return showModalBottomSheet<T>(
      context: this,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      isScrollControlled: isScrollControlled,
      useSafeArea: useSafeArea,
      backgroundColor: backgroundColor,
      shape: shape,
      clipBehavior: clipBehavior,
      builder: (_) => child,
    );
  }

  PersistentBottomSheetController persistentBottomSheet<T>({
    required Widget child,
    Color? backgroundColor,
    ShapeBorder? shape,
    Clip? clipBehavior,
    bool enableDrag = true,
    bool showDragHandle = false,
  }) {
    return showBottomSheet(
      context: this,
      backgroundColor: backgroundColor,
      shape: shape,
      clipBehavior: clipBehavior,
      enableDrag: enableDrag,
      showDragHandle: showDragHandle,
      builder: (_) => child,
    );
  }

  // ---------------------------------------------------------------------------
  // SnackBars
  // ---------------------------------------------------------------------------

  ScaffoldMessengerState get messenger => ScaffoldMessenger.of(this);

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> snackBar(
    SnackBar snackBar,
  ) {
    messenger.hideCurrentSnackBar();
    return messenger.showSnackBar(snackBar);
  }

  ScaffoldFeatureController<MaterialBanner, MaterialBannerClosedReason> banner(
    MaterialBanner banner,
  ) {
    messenger.hideCurrentMaterialBanner();
    return messenger.showMaterialBanner(banner);
  }

  void hideSnackBar() => messenger.hideCurrentSnackBar();

  void hideBanner() => messenger.hideCurrentMaterialBanner();
}
