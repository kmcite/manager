import 'package:flutter/material.dart';

class Feature<T extends ChangeNotifier> extends StatefulWidget {
  final Widget Function(BuildContext, T) builder;
  final T Function() created;
  Feature({
    super.key,
    required this.builder,
    required this.created,
  });

  @override
  State<StatefulWidget> createState() {
    return FeatureState<T>();
  }
}

class FeatureState<T extends ChangeNotifier> extends State<Feature<T>> {
  late T created;
  @override
  void initState() {
    super.initState();
    created = widget.created();
    created.addListener(listener);
  }

  void listener() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, created);
  }

  @override
  void dispose() {
    created.removeListener(listener);
    super.dispose();
  }
}
