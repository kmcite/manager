import 'dart:developer' show log;

import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/widgets.dart' show Widget;

/// ===============================================================
/// 🌍 GLOBAL CONTAINER
/// ===============================================================

final ProviderContainer global = ProviderContainer();

final class ProviderContainer {
  final Map<Provider<Object>, Object> _instances = {};

  late final ServiceRef service = _ServiceRef(this);
  late final RepositoryRef repository = _RepositoryRef(this);
  late final ControllerRef controller = _ControllerRef(this);

  T resolve<T extends Object>(Provider<T> provider) {
    final existing = _instances[provider as Provider<Object>];

    if (existing != null) {
      if (kDebugMode) {
        log('📖 Reading Layer', name: 'Cache → $T');
      }
      return existing as T;
    }

    if (kDebugMode) {
      log('🟢 Creating Layer', name: 'Init → $T');
    }

    final created = provider._create(this);
    _instances[provider] = created;
    return created;
  }

  void dispose() {
    for (final instance in _instances.values) {
      if (instance is Disposable) {
        instance.dispose();
      }
    }
    _instances.clear();
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
  const ServiceProvider(this._factory);

  final T Function() _factory;

  @override
  T _create(ProviderContainer _) => _factory();
}

final class RepositoryProvider<T extends Repository> extends Provider<T> {
  const RepositoryProvider(this._factory);

  final T Function(ServiceRef ref) _factory;

  @override
  T _create(ProviderContainer container) => _factory(container.service);
}

final class ControllerProvider<T extends Controller> extends Provider<T> {
  const ControllerProvider(this._factory);

  final T Function(RepositoryRef ref) _factory;

  @override
  T _create(ProviderContainer container) => _factory(container.repository);
}

/// ===============================================================
/// 🏭 FACTORIES
/// ===============================================================

ServiceProvider<T> service<T extends Service>(
  T Function() create,
) => ServiceProvider(create);

RepositoryProvider<T> repository<T extends Repository>(
  T Function(ServiceRef ref) create,
) => RepositoryProvider(create);

ControllerProvider<T> controller<T extends Controller>(
  T Function(RepositoryRef ref) create,
) => ControllerProvider(create);

/// ===============================================================
/// 🔗 REFERENCES
/// ===============================================================

abstract interface class ServiceRef {
  T call<T extends Service>(ServiceProvider<T> provider);
}

abstract interface class RepositoryRef {
  T call<T extends Repository>(RepositoryProvider<T> provider);
}

abstract interface class ControllerRef {
  T call<T extends Controller>(ControllerProvider<T> provider);
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

final class _ControllerRef implements ControllerRef {
  const _ControllerRef(this._container);

  final ProviderContainer _container;

  @override
  T call<T extends Controller>(ControllerProvider<T> provider) =>
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

abstract class Controller {
  const Controller();
}

/// Optional automatic disposal.
abstract interface class Disposable {
  void dispose();
}

/// ===============================================================
/// 🧩 WIDGET EXTENSION
/// ===============================================================

extension WidgetUse on Widget {
  T use<T extends Controller>(
    ControllerProvider<T> provider,
  ) {
    // Ensures the controller is created before the widget is shown.
    // Returns the original widget unchanged.
    return global.controller(provider);
  }
}
