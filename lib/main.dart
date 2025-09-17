import 'package:application/application.dart';
import 'package:data/data.dart';
// main entrypoint wiring

import 'app/app.dart';
import 'bootstrap.dart';
import 'config/runtime.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  final overrides = <Override>[
    if (RuntimeConfig.useFirebaseAuth)
      authRepositoryProvider.overrideWith((ref) => FirebaseAuthRepository())
    else
      authRepositoryProvider.overrideWithValue(InMemoryAuthRepository()),
    if (RuntimeConfig.useFirestoreTasks)
      tasksRepositoryProvider.overrideWith((ref) => FirestoreTasksRepository())
    else
      tasksRepositoryProvider.overrideWithValue(InMemoryTasksRepository()),
  ];

  bootstrap(
    const App(),
    overrides: overrides,
  );
}
