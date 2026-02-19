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

1. Create a new feature folder under `lib/core/features/your_feature` with subfolders for `models`, `screens`, `widgets`, and `bloc`/`providers` (or state solution of choice).
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

## Contributing

Contributions are welcome. Suggested workflow:

1. Fork the repo.
2. Create a feature branch: `git checkout -b feat/your-feature`
3. Add tests for new behavior.
4. Open a pull request with a clear description of changes.

Please follow the project's coding style and write tests for non-trivial changes.

## Troubleshooting & FAQ

- If `flutter pub get` fails, run `flutter pub cache repair` and re-run `flutter pub get`.
- If platform builds fail, run `flutter clean` and re-run the build.

## Where to Edit the README

This repository's short landing page is [README.md](README.md). Use the `docs/DOCUMENTATION.md` as the canonical, detailed developer documentation and keep `README.md` focused on a short overview and quickstart.

## License

If a license is not present, add one (e.g., MIT) at the repository root as `LICENSE`.

---

If you'd like, I can:

- Sync key sections into `README.md`.
- Generate a smaller `CONTRIBUTING.md` and `CHANGELOG.md`.
- Add example screenshots and usage GIFs (you can point me to assets).
