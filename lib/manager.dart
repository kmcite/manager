import 'package:flutter/material.dart' show StatefulWidget, State;

/// collection // repository api
export 'collection.dart';
export 'model.dart';

/// useful extensions
export 'extensions.dart';
export 'locator.dart';

/// notifier and notifier provider
export 'feature.dart';

extension Listener<T extends StatefulWidget> on State<T> {
  void listener() {
    // ignore: invalid_use_of_protected_member
    if (mounted) setState(() {});
  }
}
