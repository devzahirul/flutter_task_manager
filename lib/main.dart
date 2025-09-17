import 'package:application/application.dart';
import 'package:data/data.dart';
// main entrypoint wiring

import 'app/app.dart';
import 'bootstrap.dart';

void main() {
  bootstrap(
    const App(),
    overrides: [
      authRepositoryProvider.overrideWithValue(InMemoryAuthRepository()),
      tasksRepositoryProvider.overrideWithValue(InMemoryTasksRepository()),
    ],
  );
}
