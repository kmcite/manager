import 'dart:developer' show log;
import 'package:flutter/foundation.dart' show kDebugMode, protected;
import 'package:flutter/widgets.dart';

/// ===============================================================
/// 🔒 CONTAINER & SCOPE
/// ===============================================================

class ProviderScope extends StatefulWidget {
  final Widget child;

  const ProviderScope({super.key, required this.child});

  @override
  State<ProviderScope> createState() => _ProviderScopeState();
}

class _ProviderScopeState extends State<ProviderScope> {
  late final ProviderContainer _container;

  @override
  void initState() {
    super.initState();
    _container = ProviderContainer();
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedProviderScope(
      container: _container,
      child: widget.child,
    );
  }
}

class _InheritedProviderScope extends InheritedWidget {
  final ProviderContainer container;

  const _InheritedProviderScope({
    required this.container,
    required super.child,
  });

  @override
  bool updateShouldNotify(_InheritedProviderScope oldWidget) {
    return container != oldWidget.container;
  }
}

final class ProviderContainer {
  final Map<Provider<Object>, Object> _instances = {};

  late final ServiceRef service = _ServiceRef(this);
  late final RepositoryRef repository = _RepositoryRef(this);
  late final PresentationRef presentation = _PresentationRef(this);

  T resolve<T extends Object>(Provider<T> provider) {
    // 1. Check if the instance already exists in cache
    final existingInstance = _instances[provider as Provider<Object>];

    if (existingInstance != null) {
      if (kDebugMode) {
        log('📖 Reading Layer', name: 'Cache → $T');
      }
      return existingInstance as T;
    }

    // 2. Create the instance if it doesn't exist
    if (kDebugMode) {
      log('🟢 Creating Layer', name: 'Init → $T');
    }

    final newInstance = provider._create(this);
    _instances[provider] = newInstance;
    return newInstance;
  }
}

/// ===============================================================
/// 📦 PROVIDERS
/// ===============================================================

sealed class Provider<T extends Object> {
  const Provider();

  T _create(ProviderContainer container);
}

final class ServiceProvider<T extends Service> extends Provider<T> {
  const ServiceProvider(this._createService);
  final T Function() _createService;

  @override
  T _create(ProviderContainer _) => _createService();
}

final class RepositoryProvider<T extends Repository> extends Provider<T> {
  const RepositoryProvider(this._createRepository);
  final T Function(ServiceRef ref) _createRepository;

  @override
  T _create(ProviderContainer container) =>
      _createRepository(container.service);
}

final class PresentationProvider<T extends Presentation> extends Provider<T> {
  const PresentationProvider(this._createPresentation);
  final T Function(RepositoryRef ref) _createPresentation;

  @override
  T _create(ProviderContainer container) =>
      _createPresentation(container.repository);
}

/// ===============================================================
/// 🏭 FACTORIES
/// ===============================================================

ServiceProvider<T> serviceProvider<T extends Service>(T Function() create) =>
    ServiceProvider(create);

RepositoryProvider<T> repositoryProvider<T extends Repository>(
  T Function(ServiceRef ref) create,
) =>
    RepositoryProvider(create);

PresentationProvider<T> presentationProvider<T extends Presentation>(
  T Function(RepositoryRef ref) create,
) =>
    PresentationProvider(create);

/// ===============================================================
/// 🔗 REFERENCES
/// ===============================================================

abstract interface class ServiceRef {
  T call<T extends Service>(ServiceProvider<T> provider);
}

abstract interface class RepositoryRef {
  T call<T extends Repository>(RepositoryProvider<T> provider);
}

abstract interface class PresentationRef {
  T call<T extends Presentation>(PresentationProvider<T> provider);
}

final class _ServiceRef implements ServiceRef {
  const _ServiceRef(this._container);
  final ProviderContainer _container;

  @override
  T call<T extends Service>(ServiceProvider<T> provider) =>
      _container.resolve(provider);
}

final class _RepositoryRef implements RepositoryRef {
  const _RepositoryRef(this._container);
  final ProviderContainer _container;

  @override
  T call<T extends Repository>(RepositoryProvider<T> provider) =>
      _container.resolve(provider);
}

final class _PresentationRef implements PresentationRef {
  const _PresentationRef(this._container);
  final ProviderContainer _container;

  @override
  T call<T extends Presentation>(PresentationProvider<T> provider) =>
      _container.resolve(provider);
}

/// ===============================================================
/// 🏗️ ARCHITECTURE
/// ===============================================================

abstract class Service {
  const Service();
}

abstract class Repository {
  const Repository();
}

abstract class Presentation {
  const Presentation();
}

/// ===============================================================
/// 🧩 UI EXTENSION
/// ===============================================================

extension BuildContextUse on BuildContext {
  @protected
  T use<T extends Presentation>(PresentationProvider<T> provider) {
    final inheritedScope =
        dependOnInheritedWidgetOfExactType<_InheritedProviderScope>();

    assert(
      inheritedScope != null,
      'No ProviderScope found in the widget tree. Ensure your widget root is wrapped in a ProviderScope.',
    );

    return inheritedScope!.container.presentation(provider);
  }
}
