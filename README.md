# Manager

A lightweight dependency injection library for Flutter.

Manager is **not** a state management package. Its only responsibility is constructing and providing your application's dependencies.

It works with any reactive solution, including:

- Signals
- Streams
- ValueNotifier
- ChangeNotifier
- Bloc
- Cubit
- RxDart
- Your own state management solution

Manager simply builds your object graph and keeps architectural boundaries clear.

---

# Philosophy

Manager follows a few simple principles.

- Dependency Injection only.
- Lazy singleton providers.
- Constructor dependency injection.
- Explicit dependencies.
- No code generation.
- No reflection.
- No runtime registration.
- Framework-independent business logic.
- Compile-time architectural boundaries.

---

# Architecture

Manager encourages a simple layered architecture.

```
Controller
      │
      ▼
Repository
      │
      ▼
Service
```

Dependencies always flow downward.

| Layer      | May depend on |
| ---------- | ------------- |
| Controller | Repository    |
| Repository | Service       |
| Service    | Nothing       |

Widgets only access Controller objects.

This prevents circular dependencies and keeps responsibilities well separated.

---

# Installation

```yaml
dependencies:
    manager:
```

---

# ProviderScope

Wrap your application once.

```dart
void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}
```

---

# Services

Services represent infrastructure.

Examples include:

- HTTP
- Database
- SharedPreferences
- Secure Storage
- File System
- Analytics
- Logging

```dart
class ApiService extends Service {
  const ApiService();

  String username() {
    return "John";
  }
}
```

Create its provider.

```dart
final apiServiceProvider =
    service(() => const ApiService());
```

---

# Repositories

Repositories contain business logic.

They consume Services.

```dart
class UserRepository extends Repository {
  const UserRepository(this.api);

  final ApiService api;

  String username() {
    return api.username();
  }
}
```

Provide dependencies through the provider.

```dart
final userRepositoryProvider = repository(
  (ref) => UserRepository(
    ref(apiServiceProvider),
  ),
);
```

---

# Controllers

Controller objects prepare data for the UI.

They consume Repositories.

```dart
class HomeController extends Controller {
  const HomeController(this.repository);

  final UserRepository repository;

  String get username => repository.username();
}
```

Provider:

```dart
final homeControllerProvider = controller(
  (ref) => HomeController(
    ref(userRepositoryProvider),
  ),
);
```

---

# Using a Controller

Widgets only consume Controller providers.

```dart
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller =
        context.use(homeControllerProvider);

    return Text(
      controller.username,
    );
  }
}
```

Repositories and Services remain outside the UI.

---

# Complete Example

```dart
//
// SERVICE
//

class ApiService extends Service {
  const ApiService();

  String username() => "John";
}

final apiServiceProvider =
    serviceProvider(() => const ApiService());

//
// REPOSITORY
//

class UserRepository extends Repository {
  const UserRepository(this.api);

  final ApiService api;

  String username() {
    return api.username();
  }
}

final userRepositoryProvider = repositoryProvider(
  (ref) => UserRepository(
    ref(apiServiceProvider),
  ),
);

//
// PRESENTATION
//

class HomePresentation extends Presentation {
  const HomePresentation(this.repository);

  final UserRepository repository;

  String get username => repository.username();
}

final homePresentationProvider = presentationProvider(
  (ref) => HomePresentation(
    ref(userRepositoryProvider),
  ),
);

//
// APP
//

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final presentation =
        context.use(homePresentationProvider);

    return Scaffold(
      body: Center(
        child: Text(
          presentation.username,
        ),
      ),
    );
  }
}
```

---

# Constructor Injection

Manager supports two styles of dependency injection.

Both are valid.

## Preferred

Declare every dependency as a constructor parameter.

```dart
class UserRepository extends Repository {
  const UserRepository(
    this.api,
    this.storage,
  );

  final ApiService api;
  final StorageService storage;
}
```

Provide dependencies in one place.

```dart
final userRepositoryProvider = repositoryProvider(
  (ref) => UserRepository(
    ref(apiProvider),
    ref(storageProvider),
  ),
);
```

This has several advantages.

- Dependencies are immediately visible.
- Classes are plain Dart objects.
- Business logic has no dependency on Manager.
- Objects are trivial to construct in tests.
- Constructors document exactly what the class needs.
- Providers become the application's composition root.

This is the recommended approach.

---

## Alternative

Manager also allows passing `Ref` objects into constructors.

```dart
class UserRepository extends Repository {
  UserRepository(ServiceRef ref)
      : api = ref(apiProvider),
        storage = ref(storageProvider);

  final ApiService api;
  final StorageService storage;
}
```

Provider:

```dart
final userRepositoryProvider =
    repositoryProvider(
      (ref) => UserRepository(ref),
    );
```

This is useful when preferred by the project or when constructing very large object graphs.

However, constructor dependency injection keeps dependencies explicit and is generally recommended.

---

# State Management

Manager intentionally does not provide state management.

Instead, use whichever approach best fits your application.

```text
Manager
        │
        ├── Signals
        ├── Streams
        ├── ValueNotifier
        ├── ChangeNotifier
        ├── Bloc
        ├── Cubit
        ├── RxDart
        └── Custom Solutions
```

A Presentation object can expose state using any mechanism.

```dart
class HomePresentation extends Presentation {
  HomePresentation(this.repository);

  final UserRepository repository;

  final counter = ValueNotifier(0);
}
```

Or

```dart
class HomePresentation extends Presentation {
  HomePresentation(this.repository);

  final UserRepository repository;

  final counter = Signal(0);
}
```

Or

```dart
class HomePresentation extends Presentation {
  HomePresentation(this.repository);

  final UserRepository repository;

  final counter = StreamController<int>.broadcast();
}
```

Manager does not impose a reactive model.

---

# Provider Lifecycle

Every provider is:

- Lazy
- Cached
- Singleton within a ProviderScope

Objects are created only when first requested.

Subsequent requests return the existing instance.

```
First use
      │
      ▼
Create object
      │
      ▼
Cache instance
      │
      ▼
Reuse instance
```

---

# Dependency Rules

Allowed

```
Presentation
        │
        ▼
Repository
        │
        ▼
Service
```

Not allowed

```
Presentation → Presentation

Presentation → Service

Repository → Repository

Service → Repository

Service → Presentation

Service → Service
```

Keeping dependencies flowing in one direction makes applications easier to understand, maintain, and test.

---

# Public API

```dart
serviceProvider(...)
repositoryProvider(...)
presentationProvider(...)

ProviderScope(...)

context.use(...)
```

Manager intentionally keeps its API small so that the architecture stays simple and the dependency graph remains explicit.
