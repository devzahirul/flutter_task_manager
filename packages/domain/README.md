Domain package
==============

Purpose
- Defines the core business types and contracts that are independent of frameworks.
- Contains only pure Dart code (no Flutter/Firebase/etc.).

Contents
- Entities/value objects: `AppUser`, `Task`.
- Repository interfaces: `AuthRepository`, `TasksRepository`.
- Barrel export: `lib/domain.dart`.

Conventions
- Keep entities immutable and comparable (e.g., Equatable).
- No side-effects or framework dependencies.
- Add new features by introducing new entities/interfaces here first (TDD).

Testing
- Run with: `dart test`
- Tests live under `packages/domain/test` and focus on entity semantics.

