import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class Router<T extends Widget> extends ChangeNotifier {
  late GoRouter config;

  DateTime? lastBack;
  Router(List<T> pages) {
    config = GoRouter(
      initialLocation: _byType(pages.first.runtimeType),
      refreshListenable: this,
      routes: [
        ShellRoute(
          builder: (context, state, child) => RouterShell(child: child),
          routes: pages.map(
            (page) {
              return GoRoute(
                path: _byType(page.runtimeType),
                builder: (context, state) => page,
              );
            },
          ).toList(),
        ),
      ],
    );
  }

  void call<P extends Widget>() {
    config.go(_byType(P));
  }

  String _byType(Type p) => '/$p';

  void onLastBackChanged(DateTime? now) {
    lastBack = now;
    notifyListeners();
  }
}

class RouterShell extends StatefulWidget {
  final Widget child;
  const RouterShell({super.key, required this.child});

  @override
  State<RouterShell> createState() => _RouterShellState();
}

class _RouterShellState extends State<RouterShell> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // 🔴 blocks system exit globally
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        final router = widget as Router;

        // if something is on stack → pop it
        if (router.config.canPop()) {
          router.config.pop();
          return;
        }

        // otherwise user is at root section
        final now = DateTime.now();
        if (router.lastBack == null ||
            now.difference(router.lastBack!) > const Duration(seconds: 2)) {
          router.onLastBackChanged(now);
          return;
        }
        SystemNavigator.pop();
      },
      child: widget.child,
    );
  }
}
