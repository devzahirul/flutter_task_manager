import 'package:application/application.dart';
import 'package:data/data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('TasksController integrates with repo: add/update/delete', () async {
    final repo = InMemoryTasksRepository();
    final container = ProviderContainer(overrides: [
      tasksRepositoryProvider.overrideWithValue(repo),
    ]);
    addTearDown(container.dispose);

    // initially empty
    final s0 = container.read(tasksControllerProvider);
    expect(s0.hasValue, isTrue);
    expect(s0.value, isEmpty);

    // add
    await container.read(tasksControllerProvider.notifier).addTask('A');
    final s1 = container.read(tasksControllerProvider);
    expect(s1.value, isNotEmpty);
    final t = s1.value!.first;
    expect(t.title, 'A');

    // toggle/update
    await container.read(tasksControllerProvider.notifier).toggleDone(t);
    final s2 = container.read(tasksControllerProvider);
    expect(s2.value!.first.isDone, true);

    // delete
    await container.read(tasksControllerProvider.notifier).deleteTask(t.id);
    final s3 = container.read(tasksControllerProvider);
    expect(s3.value, isEmpty);
  });
}
