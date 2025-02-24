Custom Dart/Flutter Database Solution
1. Storing a Single Instance of Type T
T? get(): Retrieves the stored instance (nullable).
put(T i): Stores or updates the instance.
Stream<T>: Emits updates when the instance changes.
API: Instance<T>
2. Storing a Collection of Type T
T? get(String id): Retrieves an instance by its unique ID.
put(T i): Adds or updates an instance in the collection.
Stream<List<T>>: Emits updates when the collection changes.
API: Collection<T>
Requirements:
Automatic Naming: The system infers file names based on the object type and whether it’s an instance or collection—no manual naming required.
File-Based Storage: Data is stored in a dedicated folder within the device’s Documents Directory, determined dynamically based on the platform.
Path Provider Integration: Uses path_provider to manage file paths efficiently.
Optimized Performance: Ensures fast retrieval, minimal overhead, and supports reactive updates.