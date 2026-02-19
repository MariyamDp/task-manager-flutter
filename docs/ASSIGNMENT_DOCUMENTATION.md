# Assignment Documentation — implementation mapping and checklist

This repository currently contains detailed developer documentation, a PlantUML architecture source, and this assignment mapping file to guide implementation and verification.


## Part 1: SOLID Implementation (40 points)

Goal: Implement the code so each of the SOLID principles is demonstrated. Below is a checklist and guidance for each requirement.

- Single Responsibility
  - Required classes (one-per-responsibility):
    - `TaskRepository` — data operations (implement in `lib/features/tasks/data/repositories/task_repository_impl.dart`)
    - `TaskValidator` — validation logic (implement in `lib/features/tasks/domain/validators/task_validator.dart`)
    - `NotificationService` — sending notifications (implement in `lib/core/services/notification_service.dart`)
    - `TaskReportGenerator` — generating reports (implement in `lib/features/tasks/domain/reports/task_report_generator.dart`)
  - Checklist:
    - [ ] Each class has a single responsibility and tests covering its behavior.

- Open/Closed
  - Implement multiple storage strategies that all implement `ITaskDataSource` placed at `lib/features/tasks/data/datasources/i_task_data_source.dart`:
    - `LocalStorageDataSource` — `lib/features/tasks/data/datasources/local_storage_data_source.dart`
    - `FirebaseDataSource` — `lib/features/tasks/data/datasources/firebase_data_source.dart`
    - `SQLiteDataSource` — `lib/features/tasks/data/datasources/sqlite_data_source.dart`
  - `TaskRepositoryImpl` should accept `ITaskDataSource` and delegate calls to it.
  - Checklist:
    - [ ] Add all three data source implementations
    - [ ] `TaskRepositoryImpl` does not change when adding a new datasource

- Liskov Substitution
  - Create Task hierarchy in `lib/features/tasks/domain/entities/`:
    - `Task` (base)
    - `RecurringTask extends Task`
    - `PriorityTask extends Task`
  - Ensure all tasks can be used in `List<Task>` without breaking behavior.
  - Checklist:
    - [ ] Unit tests verify substitutability (e.g., pass `RecurringTask` into functions expecting `Task`).

- Interface Segregation
  - Create focused interfaces in `lib/core/interfaces/`:
    - `Readable` — read operations
    - `Writable` — write operations
    - `Deletable` — delete operations
  - Classes implement only what they need (e.g., read-only repository implements `Readable`).

- Dependency Inversion
  - In `lib/features/tasks/domain/repositories/` define `ITaskRepository`.
  - `TaskRepositoryImpl` depends on `ITaskDataSource` (abstraction).
  - `TaskController` (or `TaskBloc`) depends on `ITaskRepository`.

---

## Part 2: Dependency Injection Setup (30 points)

Goal: Setup `injectable` + `get_it` with the required structure.

- Required project layout (examples provided):

```
lib/
├── core/
│   └── di/
│       ├── injection.dart
│       └── injection.config.dart (generated)
├── features/
│   └── tasks/
│       ├── data/
│       │   ├── datasources/
│       │   ├── repositories/
│       │   └── models/
│       ├── domain/
│       │   ├── entities/
│       │   ├── repositories/
│       │   └── usecases/
│       └── presentation/
│           ├── bloc/
│           └── pages/
```

- Registration guidance:
  - Use `@injectable` for use cases.
  - Use `@lazySingleton` for repositories.
  - Use `@singleton` for longer-lived services (e.g., `NotificationService`).
  - Create an `@module` class for external deps (e.g., `SharedPreferences`, `Dio`, database instance) in `lib/core/di/external_module.dart`.
  - Use `@Environment('dev')` and `@Environment('prod')` to register mock vs. real datasources.

- Example snippets

`lib/core/di/injection.dart` (entrypoint):

```dart
final getIt = GetIt.instance;

@injectableInit
void configureDependencies(String environment) =>
  $initGetIt(getIt, environment: environment);
```

`lib/features/tasks/data/repositories/task_repository_impl.dart`:

```dart
@LazySingleton(as: ITaskRepository)
class TaskRepositoryImpl implements ITaskRepository {
  final ITaskDataSource dataSource;
  TaskRepositoryImpl(this.dataSource);

  Future<List<Task>> getTasks() => dataSource.getTasks();
}
```

---

## Part 3: Testing (30 points)

Goal: Provide unit tests, repository tests, BLoC tests, and integration tests.

- Unit tests with `mocktail` and `test` live under `test/`.
- Example test for a use case:

```dart
test('should get tasks from repository', () async {
  final mockRepo = MockTaskRepository();
  final useCase = GetTasksUseCase(mockRepo);

  when(() => mockRepo.getTasks())
    .thenAnswer((_) async => [Task(id: '1', title: 'Test')]);

  final result = await useCase();

  expect(result.length, 1);
  verify(() => mockRepo.getTasks()).called(1);
});
```

- Checklist:
  - [ ] Unit tests for validators, repositories (with mocked datasources), and use cases
  - [ ] BLoC/Controller tests with mocked use cases
  - [ ] Integration tests covering create-read-update-delete flow

  ---

  ## Final implementation mapping — how the code meets each requirement

  Below is a definitive mapping from the assignment requirements to the actual code in this repository. Each bullet shows the requirement, where it's implemented, and a short explanation.

  - Single Responsibility
    - `TaskRepository` (data operations): [lib/features/tasks/data/repositories/task_repository_impl.dart](lib/features/tasks/data/repositories/task_repository_impl.dart) — implements `ITaskRepository`, delegates to `ITaskDataSource`, and performs sorting so pinned tasks are shown first.
    - `TaskValidator` (validation logic): [lib/features/tasks/domain/services/task_validator.dart](lib/features/tasks/domain/services/task_validator.dart) — validates title and deadline.
    - `NotificationService` (sending notifications): [lib/features/tasks/domain/services/notification_service.dart](lib/features/tasks/domain/services/notification_service.dart) — singleton placeholder service registered in DI.
    - `TaskReportGenerator` (generating reports): [lib/features/tasks/domain/services/task_report_generator.dart](lib/features/tasks/domain/services/task_report_generator.dart) — produces a simple Completed/Pending summary.

  - Open/Closed
    - `ITaskDataSource` interface: [lib/features/tasks/data/datasources/task_data_source.dart](lib/features/tasks/data/datasources/task_data_source.dart)
    - Implementations:
      - `LocalStorageDataSource`: [lib/features/tasks/data/datasources/local_storage_data_source.dart](lib/features/tasks/data/datasources/local_storage_data_source.dart) (`@Environment('dev')`)
      - `FirebaseDataSource`: [lib/features/tasks/data/datasources/firebase_data_source.dart](lib/features/tasks/data/datasources/firebase_data_source.dart) (`@Environment('cloud')`)
      - `SQLiteDataSource`: [lib/features/tasks/data/datasources/sqlite_data_source.dart](lib/features/tasks/data/datasources/sqlite_data_source.dart) (`@Environment('prod')`)
      - `InMemoryDataSource` (demo/pure DI): [lib/features/tasks/data/datasources/in_memory_data_source.dart](lib/features/tasks/data/datasources/in_memory_data_source.dart)
    - `TaskRepositoryImpl` depends on `ITaskDataSource` and therefore new datasource implementations can be added without changing repository code.

  - Liskov Substitution
    - `Task` inheritance: base and subtypes at [lib/features/tasks/domain/entities/task.dart](lib/features/tasks/domain/entities/task.dart) (`Task`, `RecurringTask`, `PriorityTask`). All subtypes extend `Task` and are used interchangeably across lists, models, and datasources.

  - Interface Segregation
    - Focused interfaces: [lib/core/interfaces/storage_interfaces.dart](lib/core/interfaces/storage_interfaces.dart) defines `Readable`, `Writable`, and `Deletable` interfaces. `ITaskRepository` composes them (see [lib/features/tasks/domain/repositories/task_repository.dart](lib/features/tasks/domain/repositories/task_repository.dart)).

  - Dependency Inversion
    - `ITaskRepository` (abstraction): [lib/features/tasks/domain/repositories/task_repository.dart](lib/features/tasks/domain/repositories/task_repository.dart)
    - `TaskRepositoryImpl` depends on `ITaskDataSource` (interface) defined at [lib/features/tasks/data/datasources/task_data_source.dart](lib/features/tasks/data/datasources/task_data_source.dart)
    - Presentation layer depends on use cases and repository abstractions via DI rather than concrete implementations. Example: `TaskBloc` is constructed with use cases and a `TaskValidator` at [lib/features/tasks/presentation/bloc/task_bloc.dart](lib/features/tasks/presentation/bloc/task_bloc.dart).

  ---

  ## Part 2: Dependency Injection Setup — evidence and notes

  - DI entry / generated:
    - DI entry: [lib/core/di/injection.dart](lib/core/di/injection.dart)
    - Generated config (committed): [lib/core/di/injection.config.dart](lib/core/di/injection.config.dart)
    - External module (SharedPreferences, Dio, Database): [lib/core/di/register_module.dart](lib/core/di/register_module.dart)

  - Annotations used
    - Use cases annotated with `@injectable` (see `lib/features/tasks/domain/usecases/`)
    - Repositories annotated with `@LazySingleton(as: ITaskRepository)` (see [lib/features/tasks/data/repositories/task_repository_impl.dart](lib/features/tasks/data/repositories/task_repository_impl.dart))
    - Services annotated with `@singleton` (see `TaskValidator`, `NotificationService`, `TaskReportGenerator`)

  - Environments supported
    - `@Environment('dev')` registers `LocalStorageDataSource` (via the generated config). Use `configureDependencies(env: 'dev')` in `lib/main.dart` to boot the app with dev datasource.
    - `@Environment('prod')` registers SQLite datasource; `@Environment('cloud')` registers remote/fake Firebase datasource.

  ---

  ## Part 3: Testing — coverage and what exists

  - Tests present:
    - `test/usecases/get_tasks_usecase_test.dart` — verifies a use case calls the repository and returns tasks.
    - `test/bloc/task_bloc_test.dart` — BLoC test verifying `LoadTasks` emits loading/loaded states (uses mocked use cases).
    - `test/widget_test.dart` — replaced with a small sanity test to avoid booting the full app in CI.

  - Recommended additions (to reach >70% coverage):
    - Data-source unit tests:
      - `LocalStorageDataSource` (mock `SharedPreferences`)
      - `SQLiteDataSource` (use in-memory `sqflite` or mock `Database`)
      - `FirebaseDataSource` (mock `Dio`) 
    - Repository tests: mock `ITaskDataSource` to verify `TaskRepositoryImpl` delegates correctly and the pinned-first sorting.
    - Entity tests: ensure `RecurringTask` and `PriorityTask` behave correctly under `List<Task>` usage.
    - Integration tests: full CRUD flow wired through DI for each environment.

  ---

  ## Bonus requirements — implemented

  - Service Locator vs Pure DI (done)
    - Service Locator implementation: standard pages use `get_it` and generated `injection.config.dart` (e.g., `TaskListPage` uses `getIt<TaskBloc>()`).
    - Pure DI implementation: `TaskListPureDIPage` demonstrates manual constructor wiring and uses `InMemoryDataSource` at [lib/features/tasks/presentation/pages/task_list_pure_di.dart](lib/features/tasks/presentation/pages/task_list_pure_di.dart) and [lib/features/tasks/data/datasources/in_memory_data_source.dart](lib/features/tasks/data/datasources/in_memory_data_source.dart).
    - Documentation: [docs/DI_COMPARISON.md](docs/DI_COMPARISON.md) explains pros/cons.

  - Scoped Dependencies (done — demo utilities)
    - `SessionScope` helper: [lib/core/di/session_scope.dart](lib/core/di/session_scope.dart) demonstrates push/pop scopes and registering session-scoped resources.
    - `UserSession` and `SessionResource` examples: [lib/core/session/user_session.dart](lib/core/session/user_session.dart) and [lib/core/session/session_resource.dart](lib/core/session/session_resource.dart).

  - Disposal Management (partial)
    - Session-scoped resources are disposed in `SessionScope.endSession()`; BLoCs and widgets use normal `dispose()` where appropriate. For annotation-driven disposal, consider adding a small convention or generator (not included here).

  - Code Generation CI (done)
    - GitHub Action: `.github/workflows/codegen_check.yml` runs `build_runner` and fails the job if generated files change. Documentation: [docs/GITHUB_ACTIONS.md](docs/GITHUB_ACTIONS.md).

  ---

  ## Remaining work to fully complete the assignment (concise checklist)

  - Add datasource unit tests (Local, SQLite, Firebase) — needed to validate storage strategies.
  - Add repository-level tests verifying sorting and delegation.
  - Add integration tests and coverage reporting, then set coverage threshold (e.g., 70%) in CI.
  - Optionally: add UI to demonstrate starting and ending sessions (`SessionScope.startSession` / `endSession`) interactively.

  If you want I can implement the datasource unit tests and repository tests next (recommended priority). I can also add the CI test/coverage job and a coverage badge in `README.md`.

---

  ## Step-by-step — reproduce, run, and extend (commands and examples)

  Follow these steps to reproduce the development workflow used while building and testing this project.

  - Install deps

  ```bash
  flutter pub get
  ```

  - Generate DI and other codegen outputs

  ```bash
  # recommended
  flutter pub run build_runner build --delete-conflicting-outputs
  # or (newer) dart run build_runner build --delete-conflicting-outputs
  ```

  - Run static analysis

  ```bash
  flutter analyze
  ```

  - Run unit tests (and collect coverage)

  ```bash
  flutter test            # run tests
  flutter test --coverage # produce coverage/lcov.info
  ```

  - Render PlantUML diagram (requires Docker or local plantuml)

  ```bash
  ./scripts/render_puml.sh
  # If you don't have Docker, install PlantUML locally and run: plantuml -tpng docs/ARCHITECTURE.puml
  ```

  - CI behavior

  - The workflow `.github/workflows/codegen_and_plantuml.yml` runs `build_runner` and fails the job when generated files change. It also attempts to render the PlantUML and commit the PNG if it differs.

  - Where generated DI is located

  - After running codegen, the generated registration entry appears at: `lib/core/di/injection.config.dart`. Commit generated files or ensure CI will fail PRs that forgot to run codegen.

  Examples — adding tests

  - LocalStorageDataSource (quick mock example using the shared_preferences test helper):

  ```dart
  import 'package:shared_preferences/shared_preferences.dart';

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final ds = LocalStorageDataSource(prefs);
    // use ds.save()/ds.readAll() in tests
  });
  ```

  - Repository test pattern (use `mocktail`):

  ```dart
  class _MockDataSource extends Mock implements ITaskDataSource {}

  test('getTasks sorting', () async {
    final ds = _MockDataSource();
    final repo = TaskRepositoryImpl(ds);
    when(() => ds.getTasks()).thenAnswer((_) async => [...]);
    final res = await repo.getTasks();
    verify(() => ds.getTasks()).called(1);
  });
  ```

  Notes and tips

  - Keep imports at top of files. The `build_runner` and `injectable_generator` are sensitive to malformed files (duplicate declarations or misplaced imports cause codegen to fail).
  - Use `SharedPreferences.setMockInitialValues({})` for deterministic tests that use local storage.
  - To add a new datasource, implement `ITaskDataSource` in `lib/features/tasks/data/datasources/`, annotate with `@LazySingleton(as: ITaskDataSource)` and optional `@Environment('...')`, then run codegen.
  - To increase test coverage, add datasource tests for `LocalStorageDataSource`, `SQLiteDataSource` (use in-memory DB or mocks), and `FirebaseDataSource` (mock Dio).

  If you'd like, I can now:
  - Add `LocalStorageDataSource` tests using `SharedPreferences.setMockInitialValues`.
  - Add a CI coverage job and a coverage badge in the `README.md`.


## Bonus Challenges (+20 points)

- Service Locator vs DI comparison: add `docs/DI_COMPARISON.md` (optional). Key points:
  - Service Locator (`get_it`) is concise and convenient but hides dependencies making unit testing slightly less explicit.
  - Pure DI (constructor injection) makes dependencies explicit and easier to mock in tests.

- Scoped dependencies: use `get_it` scopes or manage object lifecycle in `injection.dart`.

- Disposal management: annotate disposers (or call `dispose()` manually) and use `@disposeMethod` if using `injectable` extensions.

- Code Generation CI: create a GitHub Action that runs `flutter pub run build_runner build --delete-conflicting-outputs` and fails if generated files are out-of-date.

---

## How I completed the requested documentation work (what was done now)

- Created `docs/DOCUMENTATION.md` — general developer docs, quickstart, architecture notes.
- Added `docs/ARCHITECTURE.puml` — PlantUML source visualizing module and DI flow.
- Added `docs/ASSIGNMENT_DOCUMENTATION.md` — this file: an ordered, assignment-aligned checklist and detailed guidance for implementing and testing each requirement.

These files provide a clear implementation plan and references to where code should live and how it should be registered with `injectable`.

---

## Next recommended steps (to finish implementation)

1. Implement interfaces and concrete classes outlined above in the specified paths.
2. Annotate classes with `injectable` annotations and run `build_runner` to generate `injection.config.dart`.
3. Implement unit and integration tests under `test/` using `mocktail`.
4. (Optional) Render `docs/ARCHITECTURE.puml` to PNG and place in `assets/docs/`.

---

If you want, I can now:

- Generate skeleton files (repositories, datasources, entities, use cases, DI module) with `injectable` annotations.
- Render the PlantUML to a PNG and add it to the repo.
- Create the GitHub Action to check `build_runner` code generation.
