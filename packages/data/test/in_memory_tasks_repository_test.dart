import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('InMemoryTasksRepository', () {
    late InMemoryTasksRepository repo;

    setUp(() {
      repo = InMemoryTasksRepository();
    });

    tearDown(() {
      repo.dispose();
    });

    test('initially empty', () async {
      expect(await repo.fetchTasks(), isEmpty);
      final first = await repo.watchTasks().first;
      expect(first, isEmpty);
    });

    test('add, update, delete and watch', () async {
      final events = <List<Task>>[];
      final sub = repo.watchTasks().listen(events.add);

      final t1 = await repo.addTask('One');
      expect(t1.title, 'One');
      expect((await repo.fetchTasks()).length, 1);

      final updated = t1.copyWith(isDone: true);
      await repo.updateTask(updated);
      final listAfterUpdate = await repo.fetchTasks();
      expect(listAfterUpdate.first.isDone, true);

      await repo.deleteTask(t1.id);
      expect(await repo.fetchTasks(), isEmpty);

      await Future<void>.delayed(Duration.zero);
      expect(events, isNotEmpty);

      await sub.cancel();
    });
  });
}
