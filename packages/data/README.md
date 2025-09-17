Data package
============

Purpose
- Implements the Domain repository interfaces using concrete data sources.
- Keeps package-internal models (DTOs) separate from Domain entities.

Structure
- src/models
  - DTOs used inside this package only: `UserDto`, `TaskDto`.
- src/in_memory
  - In-memory implementations: `InMemoryAuthRepository`, `InMemoryTasksRepository`.
- src/firebase
  - Firebase/Firestore implementations: `FirebaseAuthRepository`, `FirestoreTasksRepository`.
- Public exports
  - See `lib/data.dart` which re-exports the repositories above.

Design notes
- Independence: data sources do NOT use Domain models internally. They work with DTOs.
- Mapping boundary: repository methods map DTO ↔ Domain at the boundary so callers see only Domain types.
- Swappability: adding a new data source means creating a new folder under `src/` and mapping its DTOs.

Usage
- Import the package and use the implementation you need:
  - `import 'package:data/data.dart';`
  - Construct either in-memory or Firebase/Firestore repositories.
- The app composes these via provider overrides in `lib/main.dart`.

Testing
- Tests mirror the source layout under `test/in_memory` and `test/firebase`.
- Firebase/Firestore tests use mocks and don’t require real network access.

Conventions
- Keep DTOs simple (no dependencies on Flutter/third-party models).
- Don’t expose DTOs in public APIs; always translate to Domain entities.

