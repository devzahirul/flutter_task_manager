# Flutter Task Manager

[![Flutter CI](https://github.com/devzahirul/flutter_task_manager/actions/workflows/flutter_ci.yml/badge.svg?branch=main)](https://github.com/devzahirul/flutter_task_manager/actions/workflows/flutter_ci.yml?query=branch%3Amain)
 [![codecov](https://codecov.io/gh/devzahirul/flutter_task_manager/branch/main/graph/badge.svg)](https://codecov.io/gh/devzahirul/flutter_task_manager)

Modular, test‑driven Flutter app using a Clean Architecture split into local packages:

- `packages/domain` — pure Dart entities and repository interfaces
- `packages/data` — repository implementations (in‑memory, Firebase/Auth, Firestore/Tasks)
- `packages/application` — state/controllers using Riverpod
- `lib` — UI, app bootstrap, provider wiring

The default runtime uses in‑memory repositories for both Auth and Tasks so you can run immediately without Firebase.

## Quick Start

- Requirements
  - Flutter 3.32+ / Dart 3.8+
  - Firebase optional (only needed if you switch to Firebase/Firestore repos)

- Install dependencies
  - `flutter pub get`

- Run the app
  - `flutter run -d chrome` (or any device)

- Run tests
  - Domain: `cd packages/domain && dart pub get && dart test`
  - Data: `cd packages/data && flutter pub get && flutter test`
  - Application: `cd packages/application && flutter pub get && flutter test`
  - App widgets: `flutter test`

## Architecture

- Domain
  - Entities: `AppUser`, `Task`
  - Interfaces: `AuthRepository`, `TasksRepository`

- Data (implementations)
  - Auth: `InMemoryAuthRepository`, `FirebaseAuthRepository`
  - Tasks: `InMemoryTasksRepository`, `FirestoreTasksRepository`

- Application (Riverpod controllers)
  - `AuthController` via `authControllerProvider`
  - `TasksController` via `tasksControllerProvider`

- UI
  - `lib/app/app.dart` — Material/Cupertino app
  - `lib/features/home/home_page.dart` — sign‑in/out and a simple task list

## Provider Wiring (DI)

Runtime provider overrides live in `lib/main.dart`:

- Defaults to in‑memory for both Auth and Tasks.
- You can switch at runtime using `--dart-define` flags (no code edits):
  - Firebase Auth: `--dart-define=USE_FIREBASE_AUTH=true`
  - Firestore Tasks: `--dart-define=USE_FIRESTORE_TASKS=true`
  - Example: `flutter run -d chrome \
      --dart-define=USE_FIREBASE_AUTH=true \
      --dart-define=USE_FIRESTORE_TASKS=true`

Under the hood, `lib/config/runtime.dart` reads the flags and `lib/main.dart` sets provider overrides accordingly.

## Firebase Setup (optional)

Only needed if using `FirebaseAuthRepository` and/or `FirestoreTasksRepository`.

- Configure with FlutterFire
  - `dart pub global activate flutterfire_cli`
  - `flutterfire configure`
  - Ensure `lib/firebase_options.dart` exists with your web/ios/android config

- Notes for Web
  - Construct Firebase‑backed repos lazily (done via provider override) to avoid init timing issues.
  - If you see init errors, verify `firebase_options.dart` and browser extensions aren’t blocking Firebase.

## Build

- Web: `flutter build web --release` → outputs to `build/web`

## Coverage

- CI generates coverage for app and all packages, merges them into `coverage/combined.info`, and uploads artifacts.
- Optional Codecov upload (using the merged report) is enabled when `CODECOV_TOKEN` is set as a repo secret.
  - Create a Codecov account and add this repo.
  - Add GitHub secret `CODECOV_TOKEN` (from Codecov) to enable uploads.

<!-- ci: trigger 2 -->

## Tests (TDD)

The repo was grown test‑first. Key tests include:

- Domain: entity equality and `copyWith` semantics
- Data: in‑memory repos + Firestore and Firebase Auth repos (mocked)
- Application: controllers/providers behavior
- UI: widget tests for sign‑in/out and task list interaction

## Repo Structure (selected)

- `packages/domain/lib/` — `src/auth/*`, `src/tasks/*`, `domain.dart`
- `packages/data/lib/` — `src/auth/*`, `src/tasks/*`, `data.dart`
- `packages/application/lib/` — `src/auth/*`, `src/tasks/*`, `application.dart`
- `lib/` — `app/*`, `features/home/home_page.dart`, `bootstrap.dart`, `main.dart`

## Notes

- Analyzer warnings about mocking sealed Firestore classes appear in tests; they don’t affect builds. We can switch to wrappers/fakes later to silence them.
- Feel free to open issues or PRs for improvements, e.g., full Firestore UI, deletion of tasks, or CI workflows.
