Application package
===================

Purpose
- Holds application state and coordinators (controllers) using Riverpod.
- Depends on Domain only; no direct data-source dependencies.

Contents
- Controllers/providers:
  - `AuthController` via `authControllerProvider`
  - `TasksController` via `tasksControllerProvider`
- Barrel export: `lib/application.dart`.

Composition
- The app (or tests) provide concrete repositories by overriding providers for:
  - `authRepositoryProvider`
  - `tasksRepositoryProvider`
- See `lib/main.dart` in the app for example overrides.

Conventions
- Keep controllers small, testable, and reactive (AsyncValue, streams).
- No UI code here; UI lives in the app package.

Testing
- Run with: `flutter test`
- Tests live under `packages/application/test` and verify controller behavior with fake repos.

