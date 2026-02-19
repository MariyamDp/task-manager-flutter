# DB Task Manager — Documentation

## Project Overview

DB Task Manager is a Flutter-based cross-platform task manager that demonstrates a clean architecture, dependency injection, and modular features for managing tasks. The app's codebase is organized under `lib/` with feature modules, core interfaces, and DI helpers.

## Key Features

- Create, update, and delete tasks
- Local persistence and (future) sync-ready structure
- Modular feature structure to simplify testing and maintenance

## Repository Layout

- **`lib/`**: Application source code.
  - [lib/main.dart](lib/main.dart): App entrypoint.
  - [lib/core/di/](lib/core/di): Dependency injection setup.
  - [lib/core/interfaces/](lib/core/interfaces): Shared interfaces and abstractions.
  - [lib/core/features/tasks/](lib/core/features/tasks): Task feature (models, screens, logic).
- **`assets/`**, **`memes/`**: Static assets used by the app.
- **`test/`**: Unit and widget tests (see [test/widget_test.dart](test/widget_test.dart)).

## Prerequisites

- Flutter SDK (stable). Install from https://docs.flutter.dev/get-started/install
- Platform tooling for targets you plan to run (Android SDK, Xcode for iOS/macOS).

## Setup & Installation

1. Clone the repo and open it in your editor/IDE of choice.

```bash
git clone <repo-url>
cd DB_task_manager
```

2. Fetch Dart/Flutter packages:

```bash
flutter pub get
```

3. If developing for mobile, ensure platform tooling is installed and configured:

```bash
# Android
flutter doctor --android-licenses

# iOS/macOS (macOS host required)
open -a Xcode
```

## Running the App

- Run on a connected Android device or emulator:

```bash
flutter run -d <device-id>
```

- Run on web:

```bash
flutter run -d chrome
```

- Build a release for Android:

```bash
flutter build apk --release
```

## Architecture and Design

The project follows a modular, feature-driven structure with separation of concerns:

- **Features**: Each feature (e.g., tasks) keeps its UI, models, and domain logic together.
- **Core**: Reusable interfaces, DI setup, and shared utilities live under `lib/core`.
- **DI (Dependency Injection)**: The DI folder under `lib/core/di` centralizes service and repository wiring so components request interfaces rather than implementations.

This approach makes the code easier to test and extend.

## Important Files and Where to Look

- App entry: [lib/main.dart](lib/main.dart)
- DI configuration: [lib/core/di/](lib/core/di/)
- Task feature sources: [lib/core/features/tasks/](lib/core/features/tasks/)
- Tests: [test/widget_test.dart](test/widget_test.dart)

## Data Models & Interfaces

Look in `lib/core/interfaces` for contracts used across the app (repositories, data sources). Implementations (local storage, remote when added) should implement these interfaces so the rest of the app remains decoupled.

## Adding a New Feature

1. Create a new feature folder under `lib/core/features/feature` with subfolders for `models`, `screens`, `widgets`, and `bloc`/`providers` (or state solution of choice).
2. Add interfaces to `lib/core/interfaces` when shared behavior is required.
3. Register concrete implementations in `lib/core/di`.

## Testing

- Run tests with:

```bash
flutter test
```

- Widget tests live in `test/` and should reference small slices of the widget tree.

## Building & Deployment Notes

- Android: `flutter build apk` or `flutter build appbundle`
- iOS/macOS: Build from Xcode for distribution or use `flutter build ios`/`flutter build macos`.

Follow Flutter's official docs for code signing and store submission steps.

## Architecture & SOLID Principles

### Dependency Flow Diagram

```
Presentation Layer (UI)
    ↓ depends on
BLoC / State Management
    ↓ depends on
Use Cases (Domain Logic)
    ↓ depends on
Repositories (Abstractions)
    ↓ depends on
Data Sources (Implementations)
    ↓ depends on
External Services (DB, SharedPreferences, Dio, etc.)
```

**Clean Architecture principle**: Each layer depends only on abstractions from the layer below, never on concrete implementations from higher layers.

### Single Responsibility Principle (SRP)

**Definition**: A class should have one reason to change.

**Implementation in this codebase**:

- **`TaskRepository`** manages storage operations and applies domain logic (pinned-first sorting). Delegates CRUD to `ITaskDataSource`, doesn't handle persistence itself.
- **`TaskValidator`** validates task input (title length, deadline). Does not save, delete, or transform tasks.
- **`NotificationService`** sends notifications when tasks are due. Decoupled from repository; called independently by BLoC if needed.
- **`TaskReportGenerator`** generates task summary reports. Only reads task state, does not modify it.

**Why it matters**: If validation rules change, only `TaskValidator` needs updates; if persistence backend changes, only datasource implementations change.

### Open/Closed Principle (OCP)

**Definition**: Classes should be open for extension but closed for modification.

**Implementation**:

- **`ITaskDataSource` interface** defines contract: `getTasks()`, `saveTask()`, `deleteTask()`, `markDone()`, `togglePin()`
- **Multiple implementations** (all implement `ITaskDataSource`):
  - `LocalStorageDataSource`: uses SharedPreferences
  - `SQLiteDataSource`: uses sqflite
  - `FirebaseDataSource`: uses Dio (stub)
  - `InMemoryDataSource`: for testing/Pure DI demo

**Why it matters**: Adding a new storage backend requires only implementing `ITaskDataSource` and registering it in DI. `TaskRepository` and all higher layers remain unchanged.

### Liskov Substitution Principle (LSP)

**Definition**: Objects of a superclass should be substitutable by subclass objects without breaking the application.

**Implementation**:

- **`Task` hierarchy**:
  - Base: `Task` (id, title, description, createdAt, deadline, isDone, isPinned, color)
  - Subtypes: `RecurringTask extends Task`, `PriorityTask extends Task`
  - All three are usable in `List<Task>` without behavior changes

**Verification in tests**: RecurringTask, PriorityTask, and Task work seamlessly in the same collection and repository operations.

### Interface Segregation Principle (ISP)

**Definition**: Clients should depend on minimal, focused interfaces, not "fat" ones.

**Implementation**:

- **Focused interfaces**: `Readable<T>` (read only), `Writable<T>` (write only), `Deletable<T>` (delete only)
- **Composition**: `ITaskRepository` composes these and adds domain-specific methods (`togglePin`, `markDone`)

**Why it matters**: A read-only task view depends only on `Readable<Task>`, not the full repository. Prevents accidental writes and reduces coupling.

### Dependency Inversion Principle (DIP)

**Definition**: High-level modules should depend on abstractions, not low-level modules.

**Implementation**:

- `TaskBloc` depends on use cases, not concrete repositories
- Use cases depend on `ITaskRepository` (interface), not implementations
- Repository depends on `ITaskDataSource` (interface), not specific datasources
- DI configuration registers implementations to interfaces: `@LazySingleton(as: ITaskRepository)`
- Environment support: `@Environment('dev')`, `@Environment('prod')`, `@Environment('cloud')` swap datasources

**Why it matters**: Testing becomes trivial — mock `ITaskDataSource` without touching repository code. Deployment swaps datasources with environment variables, not code rewrites.

---

## Service Locator vs Pure Dependency Injection

This repo demonstrates both patterns:

- **Service Locator (get_it + `injectable`)**: Default for main app pages. Centralized, concise, environment-aware codegen. Hides dependencies but simplifies setup.
- **Pure DI (constructor injection)**: Demo page `TaskListPureDIPage` shows manual wiring. Dependencies explicit, easier to test, but more boilerplate.

## Troubleshooting & FAQ

- If `flutter pub get` fails, run `flutter pub cache repair` and re-run `flutter pub get`.
- If platform builds fail, run `flutter clean` and re-run the build.

